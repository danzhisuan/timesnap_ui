import { BusinessError } from '@kit.BasicServicesKit'
import {  MinePage_MyCollections } from './MinePage_MyCollections'
import { MinePage_MyLikes } from './MinePage_MyLikes'
import {MinePage_MyPosts} from './MinePage_MyPosts'
import { UserStore } from '../common/userStore'
import http from '@ohos.net.http'


interface User {
  user_id: string
  avatar: string
  name: string
  introduction: string
  follower_count: number
  followee_count: number
  like_count: number
  collect_count: number
}

@Entry
@Component
export struct MinePage {
  @State currentTabIndex: number = 0;
  @State user: User={
    user_id:' ',
    avatar: ' ',
    name: ' ',
    introduction: ' ',
    follower_count:0,
    followee_count:0,
    like_count:0,
    collect_count:0
  }
  private currentUserId: string = UserStore.userId; // 当前用户 ID
  aboutToAppear(): void {
    const userId = UserStore.userId;
    const url = `http://47.117.0.254:4000/users/${userId}/mine`;
    const httpRequest = http.createHttp()
    httpRequest.request(
      url,
      {
        method: http.RequestMethod.GET,
      }
    ).then((response: http.HttpResponse) => {
      console.info('数据解析成功：')
      if (typeof response.result === 'string') {
        try {
          const detail: User = JSON.parse(response.result);
          this.user = detail;
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
      // 上半部分：用户信息区
      Column() {
        // 头像 + 昵称 + 账号
        Row() {
          Image(this.user.avatar)
            .borderRadius(64)
            .margin({ top: 16, right: 16 })
            .width(90)
            .height(90)

          Column() {
            Text(this.user.name)
              .fontSize(32)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)

            Text('账号：' + this.user.user_id)
              .fontSize(20)
              .fontColor(Color.White)
              .margin({ top: 4 })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .justifyContent(FlexAlign.Start)

        // 简介
        Text(this.user.introduction)
          .fontSize(18)
          .fontColor(Color.White)
          .margin({ top: 24 })
          .width('100%')
          .textAlign(TextAlign.Start)

        // 关注、粉丝、获赞、收藏
        Row() {
          Column() {
            Text(this.user.followee_count.toString())
              .fontSize(20)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
            Text('关注')
              .fontSize(16)
              .fontColor(Color.White)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)

          Column() {
            Text(this.user.follower_count.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('粉丝')
              .fontSize(16)
              .fontColor(Color.White)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)

          Column() {
            Text(this.user.like_count.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('获赞')
              .fontSize(16)
              .fontColor(Color.White)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)

          Column() {
            Text(this.user.collect_count.toString())
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('收藏')
              .fontSize(16)
              .fontColor(Color.White)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)
        }
        .margin({ top: 32 })

        // 编辑资料 & 设置按钮
        Row() {
          Button() {
            Row() {
              Text('编辑资料')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
            }
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height('100%')
          }
          .type(ButtonType.Capsule)
          .backgroundColor('#808080')
          .borderColor(Color.White)
          .borderWidth(2)
          .width(120)
          .height(40)
          .borderRadius(20)
          .margin({ right: 24 })
          .onClick(() => {
            let uiContext: UIContext = this.getUIContext();
            let router = uiContext.getRouter();
            router.pushUrl({ url: 'pages/EditProfile' })
              .then(() => console.info('跳转到编辑资料页成功'))
              .catch((err: BusinessError) => {
                console.error(`跳转失败: Code=${err.code}, Message=${err.message}`);
              });
          })

          Image($r('app.media.setting'))
            .width(24)
            .height(24)
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              let router = uiContext.getRouter();
              router.pushUrl({ url: 'pages/Editing' })
                .then(() => console.info('跳转到设置页成功'))
                .catch((err: BusinessError) => {
                  console.error(`跳转失败: Code=${err.code}, Message=${err.message}`);
                });
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .margin({ top: 24 })
      }
      .backgroundColor("#808080")
      .width('100%')
      .height('50%')
      .padding({ left: 16, right: 16 })

      // 下半部分：切换标签
      Row() {
        Text('我的发布')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.currentTabIndex === 0 ? Color.Black : Color.Gray)
          .onClick(() => this.currentTabIndex = 0)

        Text('收藏')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.currentTabIndex === 1 ? Color.Black : Color.Gray)
          .onClick(() => this.currentTabIndex = 1)

        Text('赞过')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.currentTabIndex === 2 ? Color.Black : Color.Gray)
          .onClick(() => this.currentTabIndex = 2)
      }
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Top)
      .padding(16)
      .justifyContent(FlexAlign.SpaceAround)

      // 分界线
      Shape()
        .height(1)
        .width('100%')
        .backgroundColor(Color.Black)

      // 内容展示
      if ([0].includes(this.currentTabIndex)) {
        MinePage_MyPosts({ userId: this.currentUserId })
      }
      else if ([1].includes(this.currentTabIndex)){
        MinePage_MyCollections({ userId: this.currentUserId })
      }
      else{
        MinePage_MyLikes({ userId: this.currentUserId })
      }
    }
    .width('100%')
    .height('100%')
  }
}
