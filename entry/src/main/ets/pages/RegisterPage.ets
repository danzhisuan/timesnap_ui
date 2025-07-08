import router from '@ohos.router';

@Entry
@Component
export default struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';

  build() {
    Column() {
      // 顶部栏：返回 + 标题
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

        Text('注册')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(22)
          .fontWeight(FontWeight.Bold);

        Blank().width(24); // 占位保持居中
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 16, right: 16 });

      // 注册表单
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

        Text('确认密码')
          .fontSize(16)
          .margin({ top: 16, bottom: 4 })
          .alignSelf(ItemAlign.Start);

        TextInput({ placeholder: '请再次输入密码' })
          .width('100%')
          .height(40)
          .type(InputType.Password)
          .padding({ left: 12 })
          .backgroundColor('#f5f5f5')
          .borderRadius(6)
          .onChange(v => this.confirmPassword = v);

        Button() {
          Text('注册')
            .fontSize(16)
            .fontColor(Color.White);
        }
        .type(ButtonType.Normal)
        .margin({ top: 32 })
        .width('100%')
        .height(40)
        .backgroundColor(Color.Green)
        .borderRadius(6)
        .onClick(() => {
          if (this.password !== this.confirmPassword) {
            console.error('两次密码不一致');
            return;
          }
          console.info(`注册：${this.username}`);
          router.pushUrl({ url: 'pages/LoginPage' });
        });
      }
      .padding({ left: 24, right: 24 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
