@Entry
@Component
export default struct StatusPage {
  build() {
    Column() {
      Text('状态界面内容')
        .fontSize(20)
        .padding(20)
    }
    .backgroundColor(Color.White)
    .borderRadius(20)
    .width('75%')
    .height('100%')
  }
}
