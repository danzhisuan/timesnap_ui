import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export default struct EditProfile {
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        // 返回按钮
        Button() {
          Image($r('app.media.back')).width(24).height(24);
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .margin({ left: 12 })
        .onClick(() => {
          console.info('点击返回按钮');
          let uiContext: UIContext = this.getUIContext();
          let router = uiContext.getRouter();
          try {
            router.back();
            console.info('成功返回个人主页');
          } catch (err) {
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            console.error(`返回失败 Code=${code}, Message=${message}`);
          }
        });

        // 居中标题
        Text('编辑资料')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        // 占位保持标题居中
        Blank().width(36); // 和按钮等宽
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)
      .width('100%');

      // 内容区
      Column() {
        Text('这是编辑资料页面的内容区域')
          .fontSize(16)
          .margin(20);
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
