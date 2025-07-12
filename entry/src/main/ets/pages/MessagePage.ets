import { BusinessError } from '@kit.BasicServicesKit';
import http from '@ohos.net.http'
import { UserStore } from '../common/userStore'

interface PreviewItem {
  avatar: string;
  name: string;
  message: string;
  conversationId: string;
  friendId:string;
}





@Entry
@Component
export struct MessagePage {
  @State previews : PreviewItem[]=[]

  aboutToAppear(): void {
    const httpRequest = http.createHttp()
    const userId = UserStore.userId;
    const url = `http://47.117.0.254:4000/contact/preview?userId=${userId}`;
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET,
      }
    ).then((response: http.HttpResponse) => {
      console.info('数据解析成功：')
      if (typeof response.result === 'string') {
        try {
          const detail: PreviewItem[] = JSON.parse(response.result);
          this.previews = detail;
          console.info('帖子详情已解析');
        } catch (e) {
          console.error('JSON 解析失败:', (e as Error).message);
        }
      } else {
        console.error('返回类型不是字符串');
      }
    }).catch((error: Error) => {
      console.error('请求失败：', error.message)
    })
  }


  build() {
    Column() {
      // 顶部区域
      Row() {
        // 赞和收藏
        Column() {
          Image($r('app.media.like')).width(36).height(36);
          Text('赞和收藏').fontSize(14);
        }
        .width('33%')
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          let uiContext: UIContext = this.getUIContext();
          let router = uiContext.getRouter();
          router.pushUrl({ url: 'pages/LikePage' })
            .catch((err: BusinessError) =>
            console.error(`跳转失败: ${err.code}, ${err.message}`)
            );
        });

        // 新增关注
        Column() {
          Image($r('app.media.person')).width(36).height(36);
          Text('新增关注').fontSize(14);
        }
        .width('33%')
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          let uiContext: UIContext = this.getUIContext();
          let router = uiContext.getRouter();
          router.pushUrl({ url: 'pages/FollowPage' })
            .catch((err: BusinessError) =>
            console.error(`跳转失败: ${err.code}, ${err.message}`)
            );
        });

        // 评论和@
        Column() {
          Image($r('app.media.message')).width(36).height(36);
          Text('评论和@').fontSize(14);
        }
        .width('33%')
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          let uiContext: UIContext = this.getUIContext();
          let router = uiContext.getRouter();
          router.pushUrl({ url: 'pages/CommentPage' })
            .catch((err: BusinessError) =>
            console.error(`跳转失败: ${err.code}, ${err.message}`)
            );
        });
      }
      .width('100%')
      .height('20%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);

      // 消息预览区
      List() {
        ForEach(this.previews, (item: PreviewItem) => {
          ListItem() {
            Row() {
              Image(item.avatar)
                .width(64)
                .height(64)
                .margin({ right: 12 })
                .borderRadius(32);

              Column() {
                Text(item.name)
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold);


                Text(item.message.length > 15 ? item.message.substring(0, 15) + '…' : item.message)
                  .fontSize(18)
                  .fontColor(Color.Gray)
                  .margin({ top: 4 });
              }
              .alignItems(HorizontalAlign.Start);
            }
            .height(100)
            .padding({ top: 10, bottom: 10, left: 16, right: 16 })
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              let router = uiContext.getRouter();
              router.pushUrl({
                url: 'pages/PrivateChat',
                params: {
                  conversationId: item.conversationId.toString(),
                  // friendId: item.friendId.toString()
                }
              })//传会话id到下个界面
                .catch((err: BusinessError) =>
                console.error(`跳转失败: ${err.code}, ${err.message}`)
                );
            });
          };
        }, (item: PreviewItem) => item.name);
      }
      .width('100%')
      .layoutWeight(1)
      .margin({ top: 10 });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
