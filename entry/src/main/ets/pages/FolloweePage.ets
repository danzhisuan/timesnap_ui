import http from '@ohos.net.http'

export interface CardItem {
  id: number;
  image: string;
  title: string;
  avatar: string;
  username: string;
  likes: number;
  isLiked: boolean;
}

@Entry
@Component
export struct HotPage {

  @State cardList: CardItem[]= []


  aboutToAppear(): void {
    const httpRequest = http.createHttp()
    httpRequest.request(
      'http://47.117.0.254:4000/posts/follow/2',
      {
        method: http.RequestMethod.GET,
      }
    ).then((response: http.HttpResponse) => {
      console.info('数据解析成功：')
      if (typeof response.result === 'string') {
        try {
          const detail: CardItem[] = JSON.parse(response.result);
          this.cardList = detail;
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

  private chunkArray(arr: CardItem[], size: number): CardItem[][] {
    let result: CardItem[][] = [];
    for (let i: number = 0; i < arr.length; i += size) {
      result.push(arr.slice(i, i + size));
    }
    return result;
  }

  build() {
    Scroll() {
      Column() {
        ForEach(this.chunkArray(this.cardList, 4), (pageItems: CardItem[], pageIndex: number) => {
          Column() {
            ForEach(this.chunkArray(pageItems, 2), (rowItems: CardItem[], rowIndex: number) => {
              Row() {
                ForEach(rowItems, (item: CardItem, itemIndex: number) => {
                  Button() {
                    Column() {
                      Image(item.image)
                        .width('100%')
                        .height('80%')
                        .borderRadius(8)
                        .objectFit(ImageFit.Cover);

                      Text(item.title)
                        .fontSize(20)
                        .margin({ top: 4 });

                      Row() {
                        Row() {
                          Image(item.avatar)
                            .width(30)
                            .height(30)
                            .borderRadius(15);

                          Text(item.username)
                            .fontSize(16)
                            .margin({ left: 6 });
                        }
                        .layoutWeight(1)
                        .alignItems(VerticalAlign.Center);

                        Row() {
                          Image(item.isLiked ? $r('app.media.liked') : $r('app.media.like'))
                            .width(24)
                            .height(24)
                            .onClick(() => {
                              console.log('点赞按钮点击了');
                              item.isLiked = !item.isLiked;
                              item.likes += item.isLiked ? 1 : -1;
                            });

                          Text(`${item.likes}`)
                            .fontSize(18)
                            .margin({ left: 4 });
                        }
                        .alignItems(VerticalAlign.Center);
                      }
                      .margin({ top: 4 });
                    }
                    .width('48%')
                    .height('48%')
                    .margin({ left: itemIndex === 1 ? '4%' : 0 });
                  }
                  .backgroundColor(Color.Transparent)
                  .onClick(() => {
                    let uiContext: UIContext = this.getUIContext();
                    let router = uiContext.getRouter();
                    router.pushUrl({
                      url: 'pages/DetailPage',
                      params: { id: item.id.toString() }  // 传入字符串类型的id
                    });
                  });
                }, (item: CardItem) => item.id.toString());
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ bottom: 12 });
            }, (_: CardItem[]) => `${pageIndex}-${_[0].id}`);
          }
          .height('100%')
          .margin({ bottom: 0 });
        }, (pageItems: CardItem[]) => pageItems[0].id.toString());
      }
      .backgroundColor("#f5f5f5");
    }
  }
}
