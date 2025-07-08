import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export default struct PublishPage {
  @State inputValue: string = '';


  build() {
    Column() {
      // 顶栏
      Row() {
        Button() {
          Image($r('app.media.back')).width(24).height(24);
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .margin({ left: 12 })
        .onClick(() => {
          let uiContext: UIContext = this.getUIContext();
          let router = uiContext.getRouter();
          try {
            router.back();
          } catch (err) {
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            console.error(`返回失败 Code=${code}, Message=${message}`);
          }
        });

        Text('写文字')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 });
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)
      .width('100%');

      // 多行输入区域
      TextArea({placeholder:('写点什么吧，上限200字'),

      })
        .width('90%')
        .height(500)
        .fontSize(16)
        .maxLength(200)
        .padding(12)
        .border({ width: 1, color: Color.Black })
        .onChange((value: string) => {
          this.inputValue = value;
        })
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 });

      // 发布按钮
      Button() {
        Text('发布')
          .fontSize(18)
          .fontColor(Color.White);
      }
      .width('90%')
      .height(50)
      .margin({ top: 20 })
      .backgroundColor(Color.Red)
      .borderRadius(8)
      .alignSelf(ItemAlign.Center)
      .onClick(() => {
        console.info(`发布内容：${this.inputValue}`);
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
