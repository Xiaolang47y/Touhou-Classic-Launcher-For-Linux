在Linux下快捷方便的使用终端来启动并游玩东方旧作。

100%代码来自Deepseek，请不放心使用。

基于莉莉云（cloud.lilywhite.cc）上的东方旧作整合。

需要安装doxbox-x。

打包版（包含游戏文件本体）下载地址：https://xiaolang47y.lanzouw.com/i2iri3nvykhe

现已支持的功能：

========================

自选择语言（中/日）。

自选择游戏。

由于TH01没有汉化版，在选择中文版时TH01将不可用。

关闭Dosbox-X后按Enter返回主页面。

游戏启动前选择是否以全屏模式进行游戏。

========================

你需要保证你的游戏目录保持以下结构，脚本才能正常运行：

    [       4096]  .
    └── [       4096]  TouhouClassicLauncherForLinux
        ├── [       4096]  dosbox-x
        │   ├── [   21415936]  cn.hdi
        │   ├── [   21415936]  jp.hdi
        │   ├── [        139]  th01_jp.conf
        │   ├── [        140]  th02_cn.conf
        │   ├── [        140]  th02_jp.conf
        │   ├── [        140]  th03_cn.conf
        │   ├── [        140]  th03_jp.conf
        │   ├── [        137]  th04_cn.conf
        │   ├── [        137]  th04_jp.conf
        │   ├── [        137]  th05_cn.conf
        │   └── [        137]  th05_jp.conf
        └── [       6604]  touhou_classic_launcher.sh


或者：

    [       4096]  .
    └── [       4096]  TouhouClassicLauncherForLinux
        └── [       4096]  dosbox-x
            ├── [   21415936]  cn.hdi
            ├── [   21415936]  jp.hdi
            ├── [        139]  th01_jp.conf
            ├── [        140]  th02_cn.conf
            ├── [        140]  th02_jp.conf
            ├── [        140]  th03_cn.conf
            ├── [        140]  th03_jp.conf
            ├── [        137]  th04_cn.conf
            ├── [        137]  th04_jp.conf
            ├── [        137]  th05_cn.conf
            ├── [        137]  th05_jp.conf
            └── [       6604]  touhou_classic_launcher.sh
