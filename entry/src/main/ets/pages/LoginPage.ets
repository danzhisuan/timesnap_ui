import router from '@ohos.router';

@Entry
@Component
export default struct LoginPage {
  @State username: string = '';
  @State password: string = '';

  build() {
    Column() {
      // 顶部栏：返回 + 标题 + 注册
      Row() {
        Button() {
          Image($r('app.media.back'))
            .width(24)
            .height(24);
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.back();
        });

        Text('登录')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(22)
          .fontWeight(FontWeight.Bold);

        Button() {
          Text('注册')
            .fontSize(16)
            .fontColor(Color.Blue);
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          router.pushUrl({ url: 'pages/RegisterPage' });
        });
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 16, right: 16 });

      // 登录表单
      Column() {
        Text('用户名')
          .fontSize(16)
          .margin({ top: 24, bottom: 4 })
          .alignSelf(ItemAlign.Start);

        TextInput({ placeholder: '请输入用户名' })
          .width('100%')
          .height(40)
          .padding({ left: 12 })
          .backgroundColor('#f5f5f5')
          .borderRadius(6)
          .onChange(v => this.username = v);

        Text('密码')
          .fontSize(16)
          .margin({ top: 16, bottom: 4 })
          .alignSelf(ItemAlign.Start);

        TextInput({ placeholder: '请输入密码' })
          .width('100%')
          .height(40)
          .type(InputType.Password)
          .padding({ left: 12 })
          .backgroundColor('#f5f5f5')
          .borderRadius(6)
          .onChange(v => this.password = v);

        Button() {
          Text('登录')
            .fontSize(16)
            .fontColor(Color.White);
        }
        .type(ButtonType.Normal)
        .margin({ top: 32 })
        .width('100%')
        .height(40)
        .backgroundColor(Color.Blue)
        .borderRadius(6)
        .onClick(() => {
          console.info(`登录：${this.username}`);
          router.pushUrl({ url: 'pages/Index' });
        });
      }
      .padding({ left: 24, right: 24 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}