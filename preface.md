# 前言

工作性质以及好奇心驱使，让我有机会接触到了不少服务框架的开发工作，在微服务框架方面也有多年的开发维护经验，希望将这些内容和感兴趣的朋友们分享。

## 微服务框架相关工作

2016年7月毕业后入职腾讯，经历过几次团队调整，由于团队技术栈的原因前前后后接触了多个开发框架，涉及C++、Java、Go、PHP、JavaScript等多种编程语言框架。好奇心驱使吧，不满足于会用这些框架，花了些精力阅读相关的源码，也算是有所收获。

2018年3月份开始接触Go语言，我们团队内部也开始逐渐使用Go语言，在leader指导下，从0到1的开发了一个微服务框架GoNeat，团队上百人使用、线上部署了2K+的服务实例。结合脚手架工具，以及高效快速地问题响应，在团队的研发效率提升上也发挥了一定的作用。因为这些，获得了2019年5月刊"**公司代码文华奖银奖**"**、**"**部门传道解惑奖**"。不能把奖励举过头顶，这里只是自我鼓励下 :)

2019年7月份开始，公司技术治理工作陆续展开，在BG技术运营部牵头下成立了框架工作组Oteam，开始致力于公司级微服务框架trpc的建设。自己也作为最早的PMC成员参与了框架设计、核心开发、推广、工具及文档建设。从0到1的过程是令人兴奋的，但是也是艰辛的，如今能获得公司各个BG业务团队的认可，甚是开心。

> 作者第一次编写该章节内容时，是2021.3。截止到2021.3，统计已经有近**14000+服务实例**线上稳定运行了；现在2024年，基于trpc开发的服务数量再创新高，各语言版本加起来已经去到6w+了。

## **为什么分享这方面内容**

绝大多数开发者，都极少有机会去从0到1的开发一个微服务框架，并且长期投入人力、精力去维护，这个跟大家从事的岗位、机遇有关。

我的领导，刚好是技术精湛又乐于帮助团队成员成长的好领导，我才能在工作的过程中有时间、精力长期地去做这方面的事情。而这正是我感兴趣的一个领域，感激领导争取给予的机会。过程中，也学习到很多经验、总结了不少教训，现在梳理一下做个分享，希望感兴趣的朋友们也能从中获得一点收获吧。

在我刚开始做框架类工作时，我觉得它是一个相对来说门槛比较高的事情，也应该有沉淀、鼓励与嘉奖。尽管确实如此，在这个领域工作多年后，对个人的定位还是渐渐向“服务者角色”发生了转变，后续在课程开发、技术文档、社区问答、培养新人等方面也开始投入更多的精力。

已是2024年，也该尽快完成一个初稿了 :) 就当作是总结吧，如果读者也觉得有所帮助，那就再好不过了！由于个人水平有限，如果有理解不对的地方，也欢迎指正。

![您的支持是我持续创作的动力](.gitbook/assets/pay.png)
