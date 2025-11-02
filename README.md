
<div align=center>
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/icon.png" width="180" height="180" align=center>
</div>
<h1 align=center>TalkDrawing妙语生画</h1>

<p align=center>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift-5.5+-fe562e"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/iOS-16%2B-blue"></a>
<a href="https://github.com/Cay-Zhang/SwiftSpeech/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat"></a>
</p>

- [📖 简介](#简介)
- [👾 功能展示](#功能展示)
- [🤯 问题和改进方向](#问题和改进方向)
- [🍺 交流 & 合作](#交流--合作)

## 简介

TalkDrawing妙语生画是一款面向3-8岁儿童的思维启蒙APP——妙语生画。在2023中国高校计算机大赛-移动应用创新赛中荣获全国三等奖。作品宣发视频[在这里](https://oss.moocollege.com/unknow/works/10648559/1DZU0mQv_1692881155076.mp4)

## 功能展示

本项目接入了百度智能云平台的[Ai绘画](https://ai.baidu.com/tech/creativity/ernie_Vilg),若需要正常使用功能二的图像生成，需在工程下的DrawingGameModel修改下列`accessToken`为你的密钥，往期工程文件的测试密钥我已经更新无效化处理。

```swift
class DrawingGameModel {
    private var accessToken = "your_access_token"
    ...
}
```

<div align=center>
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/1.png" width="472" height="328">
</div>

TalkDrawing有三大功能以下三大功能：

### 故事闯关式涂鸦

在故事闯关式涂鸦，可选择故事进行闯关----目前准备了经典儿歌板块的《门前大桥下》和《小燕子》以及四大名著板块的《石猴出世》----每个故事可以根据语音提醒进行相应的交互，正确的操作能够触发故事情节的推进，直至完成故事闯关。点击顶部故事标题旁边的小喇叭可以播放整个故事。

<div align=center>
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/2.png" width="472" height="328">
</div>

### 语音日记式涂鸦

该模块中可以拿起画笔尽情涂鸦，遇到不会的画的情景或者物品可以点击左下角的语音按钮进行描述，检查灰色区域文字描述是否与所说一致。若一致则可以点击灰色区域等待8-15秒则可生成提示图片。此外，可点击右上角向右➡️跳转到下一个模块。最后可以保存连环画，手机相册和我是"故事演说家-宝宝作品"都能留有记录。

<div align=center>
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/3.gif" width="472" height="328">
</div>

### 我是故事演说家

该模块中可以点击故事情节回顾，自动播放视频和音频回顾故事。然后点击亲子分享乐园，随后立即点击下面蓝色语音按钮进行故事讲述，完成讲述后点击停止录音。再点击"语言能力分析"可以查看语言能力分析报告。


<p align=center>
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/4.png" width="354" height="246">
<img src="https://raw.githubusercontent.com/WHlcj/ImageHost/main/TalkDrawing/ReadmeAssets/5.png" width="354" height="246">
</p>


## 问题和改进方向

- 为了一体化演示当前作品资源都存储在工程目录中，包体积大小50m+，有待改进。

## 交流 & 合作

您可以通过以下几种方式支持我的项目：

- 分享项目：如果您认为我的项目非常有价值，那么请考虑分享项目链接给您的朋友和同事。这将有助于我的项目得到更多的关注和支持。如果可以请给一个小小的star！

- 提供反馈：您可以通过提交Issues或者Pull Requests来帮助改进我的项目。如果您发现了任何错误或者您认为我的项目可以改进的地方，欢迎随时向我提供反馈。

- 与我合作：如果您对该项目感兴趣，想加入开发或有定制化需求，欢迎随时与我联系。

总之，非常感谢您对我的项目的支持，我将持续完善这个项目，让它更好地为您提供参考和服务。

