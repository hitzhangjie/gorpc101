# GoRPC101

## 内容简介

微服务框架是微服务架构的重要基石，业界有非常多的微服务框架，Go简单优雅的设计吸引了很多企业的注意力，相关的框架也层出不穷，Google的grpc-go、字节跳动的KiteX、B站的Kratos、Alibaba的dubbo-go、腾讯的trpc-go等等，一个框架最终能否被广泛接受，除了整体的架构设计、扩展性是否优秀，也与其编码实现、性能优化、代码质量（代码规范、可读性、可测试性）、配套工具、文档完善度、生态丰富度、良好的社区运营有很重要关系。

作者在腾讯长期从事微服务框架建设相关的工作，在这个过程中收获很大。遗憾的是这些有价值的知识，零零散散地以个人感悟、项目文档、经验分享的形式散落在网络的各个角落，故作者决定整理框架建设背后的故事，并力求给读者还原一个真实的微服务框架从0到1建设的完整过程，希望读者能从中学到技术，也能收获开源项目管理的相关经验。

实际上，在作者2018.7~2019.7开发 [Go-Neat框架](https://www.hitzhangjie.pro/blog/2020-02-04-goneat-rpc%E6%A1%86%E6%9E%B6%E8%AE%BE%E8%AE%A1%E8%AF%A6%E8%A7%A3/) 期间，就产生了编写该电子书的想法，那时候trpc还未立项。2022年由于trpc存在开源、部分专利申请的前置工作需要，尽管本人也是核心开发者之一，但毕竟成果属于大家，为了“避嫌”暂停了本电子书内容的编写。曾经和oteam团队沟通是否希望写一本书来介绍下trpc诞生的过程、思考，被婉拒。此后也曾经想以grpc为例进行说明，后面又碰到2022.7组织架构调整、转岗Timi工作内容发生较大变化，没有精力来继续。现在trpc已经开源、相关技术文档也已经大部分公开，不再有上述顾虑，故而可以继续了。

## 读者对象

本电子书读者对象，包括但不限于：

- gophers，书中有很多go标准库使用、性能优化的案例；
- 微服务框架开发人员，书中介绍了微服务框架的核心设计思想、技术细节；
- 想了解框架建设过程的读者，书中尽可能还原了从0到1开发框架的故事全景；
- 对开源项目维护感兴趣的读者，书中介绍了框架建设、推广、维护过程中的经验；
- 对代码质量感兴趣的读者，书中介绍了如何系统性保证代码质量的经验；

## 本书特色

市面上介绍Go语言基础、微服务架构、grpc微服务框架应用的书籍有很多，但是从0到1讲述微服务框架诞生背后那些事的书籍几乎是空白。

业界有非常多的微服务框架，Go优秀的并发处理能力降低了微服务框架设计的门槛，微服务框架层出不穷，但是几乎没有书籍来系统性地介绍微服务框架从0到1建设的完整历程，相关内容零零散散地以个人感悟、项目文档、经验分享的形式散落在互联网的各个角落。很多开发人员在其整个职业生涯期间，可能也没有机会去接触、长时间跟进微服务框架建设相关的工作，他们也希望了解这背后的故事，而这些故事本身也很有价值。

所以我要写这本书，对过去的工作做个总结，也和感兴趣的朋友做个分享。特别提下，尽管我们主要是介绍框架的设计、实现、优化，但不局限于“特定”框架，也不局限于框架“开发”。框架建设是腾讯这些年技术治理工作的一环，在推进技术治理工作过程中，很多有价值的实践也被引入到框架本身的建设中来，如 EPC (Engineering Performance Certification) 中的代码规范、代码评审、测试覆盖等代码质量方面的最佳实践，另外云原生、CI/CD、多环境、配置管理、制品库管理、自动化测试、录制回放、混沌演练等等的诉求也影响了我们对框架整体扩展性的设计。

我已经迫不及待想完成本书内容，让它跟感兴趣的读者朋友见面了 :)

> 截止2024.1.22，腾讯微服务框架 [trpc](https://github.com/trpc-group) 已经开源了cpp, go, java版本。在trpc出现之前，腾讯内部也有一些设计实现不错的框架，如spp、jungle、neat、going，但是它们都存在十分明显的扩展性问题，无法满足不同团队业务需要。2019年借着公司技术治理的这股春风，trpc就这样诞生了。trpc借鉴了业界流行框架的长处、框架开发的经验教训，总的来看trpc还是比较好地解决了旧框架存在的诸多问题，让业务开发能够轻装上阵、把精力更多地放在业务能力本身。
>
> 借此契机，也为trpc打个call！
