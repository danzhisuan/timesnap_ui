import { BusinessError } from '@kit.BasicServicesKit'
import http from '@ohos.net.http'
import { UserStore } from '../common/userStore'
import router from '@ohos.router';


interface User {
  user_id: string;
  avatar: string;
  name: string;
}

interface ChatItem {
  time: string;
  content: string;
  isImage?: boolean;
  user: User;
}

interface PrivateChatParams {
  conversationId: string;
}

@Entry
@Component
export default struct PrivateChat {
  @State showMediaPanel: boolean = false;
  @State messages: ChatItem[]=[];
  @State targetUser: User = {
    user_id: '',
    avatar: '',
    name: ''
  }
  private currentUserId: string = UserStore.userId; // 当前用户 ID

  @State conversationId: string = '1'

  @State inputValue: string = '';
  private inputController: TextInputController = new TextInputController();

  onPageShow(): void {
    const params = router.getParams() as PrivateChatParams;
    this.conversationId = params.conversationId;
    console.info('接收到会话ID:', this.conversationId);
  }

  aboutToAppear(): void {
    const httpRequest = http.createHttp();
    const url = `http://47.117.0.254:4000/conversations/${this.conversationId}/messages`;
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET,
      }
    ).then((response: http.HttpResponse) => {
      if (typeof response.result === 'string') {
        try {
          const detail: ChatItem[] = JSON.parse(response.result)
          this.messages = detail
          // 自动从消息中获取 targetUser（第一个不是当前用户的 user）
          const otherUser = detail.find(msg => msg.user.user_id !== UserStore.userId)?.user
          if (otherUser) {
            this.targetUser = {
              user_id: otherUser.user_id,
              avatar: otherUser.avatar,
              name: otherUser.name
            }
          }
          console.info('消息已解析并设置 targetUser')
        } catch (e) {
          console.error('JSON 解析失败:', (e as Error).message)
        }
      } else {
        console.error('返回类型不是字符串')
      }
    }).catch((error: Error) => {
      console.error('请求失败：', error.message)
    })
  }

  sendMessage(): void {
    if (this.inputValue.trim() === '') {
      return;
    }
    const newMessage: ChatItem = {
      time: new Date().toISOString(),
      content: this.inputValue,
      isImage: false,
      user: {
        user_id: UserStore.userId,
        avatar: UserStore.avatar,
        name: UserStore.name
      }
    }
    // 本地添加到消息列表
    this.messages.push(newMessage)
    // 清空输入框
    this.inputValue = ''

    //将消息发送到后端
    const httpRequest = http.createHttp()
    httpRequest.request(
      'http://47.117.0.254:4000/conversations/1/messages',
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify({
          userId: UserStore.userId,
          content: newMessage.content,
          isImage: false
        })
      }
    ).then((response: http.HttpResponse) => {
      console.info('消息已发送：', response.responseCode)
    }).catch((error: Error) => {
      console.error('发送消息失败：', error.message)
    })
  }


  build() {
    Column() {
      // 顶栏
      Row() {
        Button() {
          Image($r('app.media.back')).width(24).height(24);
        }
        .type(ButtonType.Normal)
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
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

        Image(this.targetUser.avatar)
          .width(48)
          .height(48)
          .margin({ left: 16, right: 8 })
          .borderRadius(24);

        Text(this.targetUser.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold);
      }
      .height(56)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White);

      // 聊天内容
      Scroll() {
        Column() {
          ForEach(this.messages, (item: ChatItem, index: number) => {
            Column() {
              Text(item.time)
                .fontSize(12)
                .fontColor(Color.Gray)
                .margin({ top: 12, bottom: 4 })
                .alignSelf(ItemAlign.Center);

              if (item.user.user_id !== this.currentUserId) {
                // 对方消息（左侧）
                Row() {
                  Image(item.user.avatar)
                    .width(40)
                    .height(40)
                    .borderRadius(20);

                  if (item.isImage) {
                    Image($r(`app.media.${item.content}`))
                      .width(120)
                      .height(120)
                      .margin({ left: 8 })
                      .borderRadius(8);
                  } else {
                    Text(item.content)
                      .fontSize(16)
                      .padding(10)
                      .margin({ left: 8 })
                      .backgroundColor('#f0f0f0')
                      .borderRadius(8);
                  }
                }
                .margin({ left: 12, right: 12 })
                .alignSelf(ItemAlign.Start);
              } else {
                // 我方消息（右侧）
                Row() {
                  if (item.isImage) {
                    Image($r(`app.media.${item.content}`))
                      .width(120)
                      .height(120)
                      .margin({ right: 8 })
                      .borderRadius(8);
                  } else {
                    Text(item.content)
                      .fontSize(16)
                      .padding(10)
                      .margin({ right: 8 })
                      .backgroundColor(Color.Green)
                      .fontColor(Color.White)
                      .borderRadius(8);
                  }
                }
                .margin({ left: 12, right: 12 })
                .alignSelf(ItemAlign.End);
              }
            }
            .width('100%')
          }, (index: number) => `${index}`);
        }
        .padding({ bottom: 32 });
      }
      .flexGrow(1)
      .layoutWeight(1)
      .width('100%')
      .backgroundColor(Color.White);

      // 输入区
      Row() {
        TextInput({
          text: this.inputValue,
          controller:this.inputController
        })
          .width('80%')
          .layoutWeight(1)
          .height(40)
          .fontSize(16)
          .padding({ left: 8, right: 8 })
          .backgroundColor('#f0f0f0')
          .borderRadius(20)
          .onChange(value => {
            this.inputValue = value;
          });



        if (this.inputValue.length === 0) {
          Button() {
            Image($r('app.media.add')).width(32).height(32);
          }
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            this.showMediaPanel = true;
          })
          .margin({ left: 8 });
        } else {
          Button() {
            Text('发送')
              .fontSize(16)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .lineHeight(24);
          }
          .width(64)
          .height(36)
          .backgroundColor(Color.Red)
          .alignSelf(ItemAlign.End)
          .borderRadius(18)
          .onClick(() => {
            this.sendMessage()
          });
        }
      }
      .height(56)
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 12, right: 12, top: 20 })
      .width('100%');

      // 多媒体弹窗
      if (this.showMediaPanel) {
        Column()
          .width('100%')
          .height('100%')
          .position({ left: 0, bottom: 0 })
          .backgroundColor('#80000000')
          .onClick(() => {
            this.showMediaPanel = false;
          });

        Column() {
          Button() {
            Text('相册').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(48)
          .backgroundColor(Color.White);

          Button() {
            Text('拍照').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(48)
          .backgroundColor(Color.White);

          Button() {
            Text('分享').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(48)
          .backgroundColor(Color.White);
        }
        .position({ left: 0, bottom: 0 })
        .width('100%')
        .backgroundColor(Color.White)
        .padding(16);
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}
