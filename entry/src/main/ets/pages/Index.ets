import { HomePage } from './HomePage';
import { HotPage } from './FolloweePage';
import PublishPage from './PublishPage';
import { MessagePage } from './MessagePage';
import { MinePage } from './MinePage';
import StatusPage from './StatusPage';


@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State showStatusLayer: boolean = false;
  @State showPublishLayer: boolean = false;

  private titles: string[] = ['首页', '关注', '发布', '消息', '我'];

  build() {
    Stack() {
      // 主界面
      Column() {
        // 顶部栏
        Row() {
          Image($r('app.media.list'))
            .width(24)
            .height(24)
            .onClick(() => {
              this.showStatusLayer = true;
            });

          Column().layoutWeight(1);

          Image($r('app.media.search'))
            .width(24)
            .height(24)
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              let router = uiContext.getRouter();
              router.pushUrl({ url: 'pages/SearchPage' }).catch(() => {});
            });
        }
        .height(50)
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 });

        // 页面内容区
        Stack() {
          if (this.currentIndex === 0) {
            HomePage();
          } else if (this.currentIndex === 1) {
            HotPage();
          } else if (this.currentIndex === 2) {
            PublishPage();
          } else if (this.currentIndex === 3) {
            MessagePage();
          } else {
            MinePage();
          }
        }.layoutWeight(1);

        // 底部导航栏
        Row() {
          ForEach(this.titles, (item: string, index: number) => {
            Column() {
              if (index === 2) {
                Image($r('app.media.add')).width(30).height(30);
              } else {
                Text(item)
                  .fontSize(14)
                  .fontColor(this.currentIndex === index ? Color.Red : Color.Gray);
              }
            }
            .width('20%')
            .padding(8)
            .onClick(() => {
              if (index === 2) {
                this.showPublishLayer = true;
              } else {
                this.currentIndex = index;
                this.showStatusLayer = false;
                this.showPublishLayer = false;
              }
            });
          }, (item: string) => item);
        }
        .height(60)
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.SpaceEvenly);
      }
      .height('100%')
      .backgroundColor(Color.White);

      // 状态弹层
      if (this.showStatusLayer) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor("#96000000")
          .onClick(() => {
            this.showStatusLayer = false;
          });

        StatusPage()
          .position({ left: 0, top: 0 })
          .width('75%')
          .height('100%')
          .backgroundColor(Color.White);
      }

      // 触发弹层
      if (this.showPublishLayer) {
        // 背景遮罩（点击关闭弹层）
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor("#80000000")
          .onClick(() => {
            this.showPublishLayer = false;
          });

        // 底部弹层白底按钮区
        Column() {
          // 从相册选择
          Button() {
            Text('从相册选择').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height('22%')
          .backgroundColor(Color.White)
          .onClick(() => {
            this.showPublishLayer = false;
            // TODO: 调用相册API
            console.info('打开相册，待实现');
          });



          // 相机
          Button() {
          Text('相机').fontSize(16).fontColor(Color.Black);
        }
          .width('100%')
          .height('22%')
          .backgroundColor(Color.White)
          .onClick(() => {
            this.showPublishLayer = false;
            // TODO: 调用相机API
            console.info('打开相机，待实现');
          })

          // 写文字
          Button() {
          Text('写文字').fontSize(16).fontColor(Color.Black);
        }
          .width('100%')
          .height('22%')
          .backgroundColor(Color.White)
          .onClick(() => {
            this.showPublishLayer = false;
            let uiContext: UIContext = this.getUIContext();
            let router = uiContext.getRouter();
            router.pushUrl({ url: 'pages/PublishPage' }).catch(() => {});
          })

          // 取消
          Button() {
          Text('取消').fontSize(16).fontColor(Color.Black);
        }
          .width('100%')
          .height('22%')
          .backgroundColor(Color.White)
          .onClick(() => {
            this.showPublishLayer = false;
          })
        }
        .position({ left: 0, bottom: 0 })
        .width('100%')
        .height('30%')
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({ left: 20, right: 20 })
      }
    }
    .height('100%');
  }
}
