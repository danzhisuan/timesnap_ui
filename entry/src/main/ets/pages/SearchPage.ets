@Entry
@Component
export default struct SearchPage {
  @State inputValue: string = '';

  build() {
    Column() {
      Row() {
        Button() {
        Image($r('app.media.back')).width(24).height(24);
      }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(40)
        .height(40)
        .onClick(() => {
          let uiContext: UIContext = this.getUIContext();
          uiContext.getRouter().back();
        })

        // 用 Stack 让输入框和假占位重叠
        Stack() {
        TextInput()
          .width('100%')
          .height(40)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .onChange((value: string) => {
            this.inputValue = value;
          });

        if (this.inputValue.length === 0) {
          Text('请输入要搜索的内容')
            .fontSize(16)
            .fontColor(Color.Gray)
            .position({ left: 12, top: 12 });
        }
      }
        .width('70%')
        .height(40)
        .margin({ left: 12, right: 12 })
        .backgroundColor('#f0f0f0')
        .borderRadius(20)

        Button() {
        Text('搜索')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black);
      }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(60)
        .height(40)
        .onClick(() => {
          // 搜索逻辑待实现
        })
      }
      .height(56)
      .padding({ left: 12, right: 12 })
      .backgroundColor(Color.White)
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Column() {
        Text('这是搜索页面的内容区域')
          .fontSize(16);
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
