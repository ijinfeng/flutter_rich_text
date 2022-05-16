
import 'package:flutter/material.dart';
import 'package:rich_text/core/rich_label.dart';

class RichTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试'),
      ),
      body: Center(
        child: RichLabel(text: TextSpan(
          text: '😭我太感动了，还得是班长呀，习惯性的早上来看看段子，结果就看到了新的活动，真的吗？让我有点不敢相信，作为一个30多岁的老社畜，玩游戏已然成为了唯一的消遣方式，但是迫于生活，已经没了为游戏一掷千金的勇气，这些都是我在购物车里放了好久的东西，既然有这么好的机会，我一定要好好的去争取一下。\n我的心愿单:三星 2TB固态硬盘 两条 2899×2=5798\n                   三星 1TB固态硬盘 一条  1499\n                   5798+1499=7297\n游戏:阿尔登法环  298\n         赛博朋克     394.79\n          双人成行     191.66\n总计:7297+283+394·79+191.66=8166.45\n中年人的心酸，我是一分钱都不敢浪费呀😣班长别嫌弃我贪心，要是能成我就是一辈子铁粉，要是不成，我还是铁粉，就当这里是我的心愿墙了。\n求求了老天，这辈子没中过大奖，让我中一次吧。\n求求进来的朋友们留下你们宝贵的评论吧。'
        )),
      ),
    );
  }
}