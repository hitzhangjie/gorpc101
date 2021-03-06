# 架构设计

## 反复推敲

一个大型软件系统的设计，通常需要经过**“架构模式、设计模式、Idioms”**这三个阶段的不断打磨：

* 架构模式，强调整体的设计原则，影响系统整体及其子系统、组件；
* 设计模式，关注各个子系统、组件及其之间的关系；
* Idioms，关注如何用编程语言的特性，来实现子系统、组件及其之间的关系；

一个框架的设计也是类似的过程，首先需要有一个顶层设计，大致阐述系统的设计原则、设计目标，并给出框架中核心组件之间的大致交互过程，并且组件之间的交互过程要反复推敲，过程中势必会涉及到组件之间依赖关系的变化。

在这里的依赖关系未最终敲定下来之前，可以写伪代码验证设计，但是不能启动开发。因为这里依赖关系的变动，最终具体到模块或组件时会影响到一些核心接口的设计，过早投入开发会因为接口变动导致代码大范围重写。要反复推敲，直到各个核心接口都稳定下来（接口中定义的方法签名不再变化或变化很小）之后，再投入开发。

框架架构设计中的这一过程，与大型软件系统的设计并无二致，都需要经历一个自顶向下、层层分解、逐步细化的过程，最终才是使用特定的编程语言来实现特定的功能。伪代码验证设计的合理性，是一个比较快速有效的方法，但有经验的架构师却可以在架构设计过程中就提前意识到设计的合理与否。

> ps: 不妨也提下网络上比较流行的问题。不会写代码的架构师不是好的架构师？架构师不需要写代码？我对这个问题的看法是，it depends，这里也有提到架构设计的不同层次，不同设计层次要求关注的点确实是不一样的，对于Idioms这个层次是必须要熟悉编程语言及平台的特性才能很好地解决问题的，如C++开发网络服务如何实现高效网络IO，Linux下通过epoll、BSD下通过kqueue。
>
> 一个好的架构师，我认为是在对技术细节有了一定的积累之后，逐步把关注的目标从点变成线、面、体的过程，而不是丢弃细节空谈架构，那样的架构就无异于“空中楼阁”了。

## 整体架构

根据前面确定的设计目标，来设计开发我们的微服务框架gorpc，gorpc的整体（功能）架构如下图所示。

![gorpc&#x6574;&#x4F53;&#x67B6;&#x6784;](../.gitbook/assets/gorpc-zheng-ti-jia-gou-she-ji-.png)

TODO 解释各个模块的作用

## 通信流程

结合上述gorpc整体架构，我们先了解下一个完整的RPC通信流程是怎样的，我们将介绍框架各个核心模块之间的关系、交互顺序、扩展点。

![gorpc&#x901A;&#x4FE1;&#x6D41;&#x7A0B;](../.gitbook/assets/gorpcrpc-tong-xin-guo-cheng-.png)

TODO 解释gorpc通信流程

## 概要设计

在建立了对框架整体架构的认识之后，我们又了解了一个完整RPC通信是如何进行的，进一步理解了框架各核心模块之间的交互逻辑，在此基础上我们可以进行概要设计了，这里我们将对各个核心模块进行必要的抽象设计，确定其大致的接口、与其它模块的依赖关系、理顺其能力边界。

![gorpc&#x6982;&#x8981;&#x8BBE;&#x8BA1;](../.gitbook/assets/image%20%2829%29.png)



TODO 解释一下这里的概要设计的逻辑

TODO 提下，详细的模块设计将在下一节进行

## 参考文献

1. [Regine Meunier](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Regine+Meunier&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4gXxDJPK08oKy83jtWSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyBaWmZ-alKvimluZlphbtYGUEAMQxpKBRAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoATCCAXoECA8QAw), [Frank Buschmann](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Frank+Buschmann&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZSgvAKLJMtCgqqtGSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyuxUl5mUrOJUWJ2fkJubl7WBlBAC-azEKUQAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoAjCCAXoECA8QBA), [Hans Rohnert](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Hans+Rohnert&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4gXxDNMMjczKTIvitWSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyeCTmFSsE5WfkpRaV7GBlBADx7_iFTwAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoAzCCAXoECA8QBQ), [Peter Sommerlad](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Peter+Sommerlad&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZSAvMykvPKknPNcrVkspOt9JPy87P1y4syS0pS8-LL84uyrRJLSzLyixax8geklqQWKQTn5-amFuUkpuxgZQQAjf0aZFEAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoBDCCAXoECA8QBg), [Michael Stal](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Michael+Stal&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4tLP1TdIT8syNy3RkslOttJPys_P1i8vyiwpSc2LL88vyrZKLC3JyC9axMrjm5mckZiaoxBckpizg5URADspXHNMAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoBTCCAXoECA8QBw), Pattern-Oriented Software Architecture : A System of Patterns, 1995



