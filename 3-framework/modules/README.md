# 模块设计

我们介绍了系统架构从单体架构向微服务架构的演变，微服务架构、service mesh中微服务框架扮演的重要作用，也介绍了一些流行的微服务框架及其创新点，如何结合业务、团队情况去选择合适的微服务框架。最后介绍了在腾讯又是如何通过自研微服务框架来兼容存量、增量服务的。

在微服务框架的整体架构设计部分，我们介绍了一个功能完备、具备良好扩展性的微服务框架会面临的一些问题，以及这些问题应该在哪些抽象层次去解决。框架整体也是由不同的模块拼接而成，每个模块解决一个子领域的专属问题，或者多个模块的协作来解决一个更复杂的问题。接下来我们就将对框架的模块设计进行探讨。

## 整体设计回顾

在进入各个具体模块的设计实现之前，为了避免大家过度陷入某个模块细节而忽视框架全貌，建议读者经常回顾下框架整体架构设计、各模块之间的协作关系，这样更有助于理解模块解决问题的影响面、价值。

高可扩展框架整体架构设计：

![gorpc整体架构](../../.gitbook/assets/gorpc-整体架构设计.png)

框架核心模块间的协作关系：

![gorpc概要设计](<../../.gitbook/assets/gorpc-概要设计.png>)

## 核心模块设计

结合前一小节的框架核心模块UML类图，这里先对核心模块进行分类，并对模块下的重要接口定义进行简单介绍，为我们进入各个模块的具体介绍做一点铺垫。

### 服务声明方式

通过声明式配置来说明一个服务支持的API以及请求、响应参数，是一种逐渐被接受的做法。IDL（Interface Definition Language）被提出，到现在流行的protocolbuffers（下文简称pb）、flatbuffer、thrift等，除了解决高效序列化、反序列化的问题，也可以用来解决接口声明的问题。

以pb为例，下面通过特有的语法声明了一个逻辑服务HelloSvr，该逻辑服务包含一个唯一的接口Hello，请求、响应参数分别是HelloReq、HelloRsp。微服务框架开发者可以开发一各工具解析该声明文件，并生成必要的胶水代码将其与框架处理逻辑打通，业务开发人员仅需要在空接口处理函数里进行“填鸭式”编码即可。

```protobuf
syntax = "proto3";
package helloworld;
option go_package="github.com/gorpc101/helloworld;"

message HelloReq{
	string msg = 1;
}
message HelloRsp{
	uint32 err = 1;
	string msg = 2;
}
service HelloSvr {
	rpc Hello(HelloReq) returns(HelloRsp);
}
```

### server端

#### 进程 vs. 服务概念

提到一个“服务”我们会倾向于将其与一个物理服务进程挂钩，在真实业务场景里面，还需要逻辑服务的概念，比如一个物理服务进程希望对外同时支持TCP、UDP、HTTP服务，并且它们各自对外暴漏的服务还有可能是不同的，举个例子说明：

```protobuf
service HelloSvr1 {
	rpc Hello1(HelloReq) returns(HelloRsp)
	rpc Bye(ByeReq) returns(ByeRsp)
}

service HelloSvr2 {
	rpc Hello(HelloReq) returns(HelloRsp)
}
```

实际上就有业务可能希望同一个服务进程能同时支持两个逻辑服务HelloSvr1、HelloSvr2，并且它们对外暴露的接口列表是有区分的，通过这种方式可以进行更细粒度的管理，而不用额外部署两个分别支持不同接口列表的服务进程。

这样的话，我们就需要对Server、Service进行一个更加准确的声明：

- Server：一个物理服务进程，它可以包含多个逻辑Service；

  ```go
  type Server struct {
  	Services []*Service
      ...
  }
  ```

- Service：一个逻辑服务，它描述了该逻辑服务准备暴漏的接口列表、传输层协议、业务协议、序列化、压缩算法等；

  ```go
  type Service struct {
      Name string 
      Methods []Method
      
      Transport string
      Protocol string
      Serialization string
      Compression string
  }
  ```

#### 网络IO：连接管理

像grpc框架目前是基于HTTP协议实现的，由于早起HTTP协议实现存在一些问题，如不支持HTTP/1.x不支持pipeline或者后续版本厂商支持的不好，导致其服务端处理性能比较低下。另外由于HTTP是基于TCP实现的，TCP存在HOL头部阻塞问题，有很多服务设计者会考虑采用UDP协议来进行数据传输。

当然我们支持QUIC协议很好，或者类似Unreal Engine在UDP基础上实现可靠UDP通信，但是业务不只是增量，也要维护存量、考虑协议迁移的成本。OK，这里不展开了。

服务端需要考虑支持TCP、UDP、QUIC、Unix等多种不同的通信方式，这些是属于七层OS协议里传输层的范畴，在服务端在哪个层次解决好呢？

```go
type TransportService interface {
    ListenAndServe(network, address string) error
}
```

注意transport是传输的含义，在网络通信这个领域，这也算是一个计算机专业术语，比如grpc里面servertransport实际上是tcp connection层次的概念，还是在强调专业术语“通信传输”，而不是服务端传输层handler“listen and server”层次的概念。

> ps：trpc中使用了ServerTransport，但是我更倾向于将transport放在连接层面的传输这一层次，而不是仅因为它字面上带有“传输”的意思，就将其用作传输层的handler。或者说仅因为clienttransport、servertransport这样可以保持接口声明对称，就这样使用。transport指的就是“传输”，它关注的是连接层面的数据读写，而非更高维的连接管理。我认为transport甚至也不应该区分为clientside、serverside，除非真的想不出更贴切的名字了。

每改变一个专业术语的含义，都相当于在“教育”别人改变已有的共识，所以这里我使用TransportService来强调这不是一个连接数据读写的层次。每个逻辑服务Service可以引用一个TransportService来负责完成连接管理。

#### 网络IO：连接读写

在TransportService建立完连接net.Conn后，我们将通过Endpoint来表示通信双方的一端，我们将在Endpoint层次完成连接收发包buffer、codec、serializer、compressor等的创建、复用、整合操作。

```go
type Endpoint struct {
    net.Conn
    
    codec codec.Codec
    serializer codec.Serializer
    compressor codec.Compressor
    
    buf []byte
}
```

#### 编解码：业务协议

```go
type Codec interface {
    Encode([]byte) ([]byte, error)
    Decode([]byte) ([]byte, error)
}
```

#### 编解码：序列化

```go
type Serializer interface {
    Marshal(any) ([]byte, error)
    Unmarshal([]byte, any) error
}
```

#### 编解码：压缩算法

```go
type Compressor interface {
    Compress([]byte) ([]byte, error)
    Decompress([]byte) ([]byte, error)
}
```

#### 请求处理

当网络IO完成了连接管理、连接数据读取、拆包、反序列化、解压缩，一个完整的客户端请求就拿到了，此时服务器就需要改请求进行处理。一个进程包含多个逻辑服务，每个逻辑服务包含多个RPC接口，那客户端必须告知服务器自己请求的是哪个逻辑服务的哪个接口。

我为框架默认协议起了个很好听的名字“whisper”：

```protobuf
syntax = "proto2";
package whisper;

// FrameHeader is the frame header of Request and Response.
//
// The encoding of FrameHeader is as follows:
//
// |-----|------------|-----------------------|-----|
// |-----|------------|-----------------------|-----|
// \ STX \ PKG Length \ Request/Response Body \ ETX \
//  0     1            5                       ~    ~+1
//
// STX: 1B (0x38)
// PKG Length: 4B (length of body)
// Req/Rsp Body: ...
// ETX: 1B (0x49)

// Request definition
//
// In Request, tracing `traceContext` is stored in map `meta`.
message Request {
  optional uint64 seqno = 1; // 包序号
  optional string appid = 2; // 业务分配ID
  optional string rpcname = 3; // rpc名称
  optional string userid = 4; // 用户ID
  optional string userkey = 5; // 用户key，鉴权用
  optional uint32 version = 6; // 协议版本
  optional bytes body = 7; // 业务包体
  map<string, string> meta = 8; // 元信息
}

// Response definition
//
// `err_code` and `err_msg` should indicate errors in framework,
// rather than business logic error or error description.
message Response {
  optional uint64 seqno = 1; // 包序号
  optional uint32 err_code = 2; // 错误码
  optional string err_msg = 3; // 错误描述信息
  optional bytes body = 4; // 业务包体
}

```

> ps：该协议定义支持unary mode RPC，不支持streaming mode RPC，对于流式RPC，实际上在我工作这些年中用到的场景比较少，所以我并不打算在该电子书第一版草稿完成前就予以支持 … 如果有时间后考虑支持。

### client端



### 工具集

