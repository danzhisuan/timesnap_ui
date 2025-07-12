import { BusinessError } from '@kit.BasicServicesKit';
import http from '@ohos.net.http'

interface Media {
  media_id: number
  url: string
}
interface Tag {
  tag_id: string
  name: string
}
interface User {
  user_id: string
  nickname: string
  avatar: string
}
interface Comment {
  comment_id: number
  post_id: string
  parent_comment_id: string | null
  user_id: string
  content: string
  comment_time: string
  like_count: number
  user: User
  medias: Media[]
  children:Comment[]
}
interface Post {
  post_id: number
  publish_time: string
  title: string
  content: string
}
interface Permission {
  view_permission: string
  comment_permission: string
}
interface Stats {
  like_count: number
  collect_count: number
  browse_count: number
  comment_count: number
  isLiked: boolean
  isCollected: boolean
}
interface PostDetail {
  post: Post
  user: User
  permission: Permission
  stats: Stats
  medias: Media[]
  tags: Tag[]
  comments: Comment[]
}

//页面传入参数 zzf写的
interface Params {
  id?: string;
}


@Entry
@Component
export default struct DetailPage {
  @State isFollowing: boolean = false;
  @State showSortDropdown: boolean = false;
  @State showMediaPanel: boolean = false;
  @State commentInputValue: string = '';
  @State showReplyInput: boolean = false;
  @State replyInputValue: string = '';
  @State replyingToId: number = -1;
  @State likeMap: Map<number, boolean> = new Map();//评论还没有isliked，临时使用


  @State postDetail: PostDetail = {
    post: {
      post_id:0,
      publish_time:' ',
      title:' ',
      content:' '
    },
    user: {
      user_id: '',
      nickname: '',
      avatar:''
    },
    permission:{
      view_permission:' ',
      comment_permission:' '
    },
    stats:{
      like_count:0,
      browse_count: 0,
      collect_count:0,
      comment_count:0,
      isLiked:false,
      isCollected:false
    },
    medias:[],
    tags:[],
    comments:[]
  };
  //连接数据库
  aboutToAppear(): void {
    let uiContext: UIContext = this.getUIContext();
    let params = uiContext.getRouter().getParams() as Params;
    if (params.id) {
      console.info('接收到的id参数:', params.id);
    } else {
      console.warn('没有传入id参数');
    }

    const httpRequest = http.createHttp()
    httpRequest.request(
      'http://47.117.0.254:4000/posts/1/detail?userId=1',
      {
        method: http.RequestMethod.GET,
      }
    ).then((response: http.HttpResponse) => {
      console.info('数据解析成功：')
      if (typeof response.result === 'string') {
        try {
          const detail: PostDetail = JSON.parse(response.result);
          this.postDetail = detail;
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
      // 顶栏
      Row() {
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

          Image(this.postDetail.user.avatar)
            .width(40)
            .height(40)
            .borderRadius(20)
            .margin({ left: 8 });

          Text(this.postDetail.user.user_id)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 6 })
            .alignSelf(ItemAlign.Center);
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Center);

        Button() {//加一个userid!=store.userid
          Text(this.isFollowing ? '已关注' : '关注')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.isFollowing ? Color.Black : Color.Red)
            .textAlign(TextAlign.Center)
            .lineHeight(24);
        }
        .width(80)
        .height(32)
        .backgroundColor(Color.Transparent)
        .borderRadius(16)
        .borderWidth(1)
        .borderColor(this.isFollowing ? Color.Black : Color.Red)
        .margin({ right: 12 })
        .onClick(() => {
          this.isFollowing = !this.isFollowing;
        });

        Button() {
          Image($r('app.media.share')).width(24).height(24);
        }
        .type(ButtonType.Normal)
        .width(40)
        .height(40)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          // 分享点击事件，暂空
        });
      }
      .height(56)
      .width('100%')
      .padding({ left: 12, right: 12 })
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White);

      // 内容区
      Scroll() {
        Column() {
          // 帖子图片
          Swiper() {
            ForEach(this.postDetail.medias, (img: Media) => {
              Image(img.url)
                .width('100%')
                .height(350)
                .objectFit(ImageFit.Contain)
            })
          }
          .indicator(true)
          .loop(false)
          .margin({ top: 12 })
          .index(0)

          // 标题
          Text(this.postDetail.post.title)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 12, bottom: 8 })
            .alignSelf(ItemAlign.Start);

          // 正文
          Text(this.postDetail.post.content)
            .fontSize(16)
            .lineHeight(24)
            .margin({ bottom: 8 })
            .alignSelf(ItemAlign.Start);

          //标签
          Row({ space: 5 }) {
            ForEach(this.postDetail?.tags ?? [], (tag: Tag) => {
              Text(`#${tag.name}`)
                .fontSize(14)
                .fontColor(Color.Blue)
                .padding({top:10,bottom:10})
            })
          }
          .align(Alignment.Start)
          .width('100%')


          // 时间
          Text(this.postDetail.post.publish_time)
            .fontSize(14)
            .fontColor(Color.Gray)
            .margin({ bottom: 8 })
            .alignSelf(ItemAlign.Start);

          // 点赞与收藏功能区
          Row() {
            // 点赞按钮与数量
            Button() {
              Image(this.postDetail.stats.isLiked ? $r('app.media.liked') : $r('app.media.like'))
                .width(20)
                .height(20);
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .onClick( () => {
              console.log('点赞按钮点击了');
              this.postDetail.stats.isLiked = !this.postDetail.stats.isLiked;
              this.postDetail.stats.like_count += this.postDetail.stats.isLiked ? 1 : -1;
            });

            Text(`${this.postDetail.stats.like_count} `)
              .fontSize(14)
              .margin({ left: 6, right: 20 })
              .alignSelf(ItemAlign.Center);

            // 收藏按钮与数量
            Button() {
              Image(this.postDetail.stats.isCollected ? $r('app.media.saved') : $r('app.media.save'))
                .width(20)
                .height(20);
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.postDetail.stats. isCollected= !this.postDetail.stats.isCollected;
              this.postDetail.stats.collect_count += this.postDetail.stats.isCollected ? 1 : -1;
            });

           Text(`${this.postDetail.stats.collect_count} `)
              .fontSize(14)
              .margin({ left: 6 })
              .alignSelf(ItemAlign.Center);
          }
          .margin({ top: 8, bottom: 12 })
          .alignItems(VerticalAlign.Center)
          .alignSelf(ItemAlign.Start);

          // 分割线
          Divider()
            .strokeWidth(1)
            .color('#e0e0e0')
            .margin({ bottom: 12 });

          // 评论标题行
          Row() {
            Text(`${this.postDetail.stats.comment_count} 条评论`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium);

            Blank().layoutWeight(1);

            Row() {
              Text('排序方式')
                .fontSize(14)
                .margin({ right: 4 });

              Button() {
                Image($r('app.media.down_arrow')).width(16).height(16);
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                this.showSortDropdown = !this.showSortDropdown;
              });
            }
            .alignItems(VerticalAlign.Center);
          }
          .margin({ bottom: 8 });

          // 下拉排序选项
          if (this.showSortDropdown) {
            Column() {
              Button() {
                Text('按最热')
                  .fontSize(16)
                  .fontColor(Color.Black);
              }
              .width('100%')
              .height(40)
              .backgroundColor('#f9f9f9')
              .onClick(() => {});

              Button() {
                Text('按最新')
                  .fontSize(16)
                  .fontColor(Color.Black);
              }
              .width('100%')
              .height(40)
              .backgroundColor('#f9f9f9')
              .margin({top : 10})
              .onClick(() => {});
            }
            .margin({ bottom: 8 });
          }

          // 评论输入行
          Row() {
            Image(this.postDetail.user.avatar)
              .width(30)
              .height(30)
              .borderRadius(15);

            TextInput({ placeholder: '说点什么吧...' })
              .layoutWeight(1)
              .height(40)
              .fontSize(16)
              .padding({ left: 8, right: 8 })
              .backgroundColor('#f0f0f0')
              .borderRadius(20)
              .margin({ left: 8 })
              .onChange((value) => {
                this.commentInputValue = value;
              });

            if (this.commentInputValue.length === 0) {
              Button() {
                Image($r('app.media.add')).width(32).height(32);
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .margin({ left: 8 })
              .onClick(() => {
                this.showMediaPanel = !this.showMediaPanel;
              });
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
              .borderRadius(18)
              .margin({ left: 8 })
              .onClick(() => {
                // 发送逻辑
              });
            }
          }
          .margin({ top: 8, bottom: 12 })
          .alignItems(VerticalAlign.Center);

          Divider()//分割线
            .strokeWidth(1)
            .color('#e0e0e0')
            .margin({ bottom: 12 });



          // 评论区
          Column() {
            ForEach(this.postDetail.comments, (comment: Comment) => {
              Column() {
                // 一级评论头部行：头像 + 昵称时间 + 点赞按钮和数
                Row() {
                  Image(comment.user.avatar)
                    .width(30)
                    .height(30)
                    .borderRadius(15)
                    .margin({ right: 8 })

                  Row() {
                    Row() {
                      Text(comment.user.nickname)
                        .fontSize(14)
                        .fontWeight(FontWeight.Medium)

                      Text(new Date(comment.comment_time).toLocaleString().slice(0, 16))
                        .fontSize(12)
                        .margin({ left: 8 })
                        .fontColor(Color.Gray)
                    }
                    .layoutWeight(1)

                    Row() {
                      Button() {
                        Image(this.likeMap.get(comment.comment_id) ? $r('app.media.liked') : $r('app.media.like'))
                          .width(24)
                          .height(24)
                      }
                      .type(ButtonType.Normal)
                      .backgroundColor(Color.Transparent)
                      .onClick(() => {
                        let current = this.likeMap.get(comment.comment_id) ?? false
                        this.likeMap.set(comment.comment_id, !current)
                        if (!current) comment.like_count += 1
                        else comment.like_count -= 1
                      })

                      Text(`${comment.like_count}`)
                        .fontSize(12)
                        .fontColor(Color.Gray)
                        .margin({ left: 4 })
                    }
                  }
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.SpaceBetween)
                  .layoutWeight(1)
                }
                .alignItems(VerticalAlign.Center)
                .margin({ bottom: 4 })

                // 一级评论正文行，对齐头像
                Row() {
                  Text(comment.content)
                    .fontSize(15)
                }
                .width('100%')
                .padding({left:35,bottom:10})

                // 一级评论图片，对齐头像
                if (comment.medias.length > 0) {
                  Row() {
                    ForEach(comment.medias, (media: Media) => {
                      Image(media.url)
                        .width(60)
                        .height(60)
                        .margin({ right: 6 })
                        .borderRadius(6)
                    })
                  }
                  .width('100%')
                  .padding({left:35,bottom:10})
                  .margin({ top: 6 })
                }

                // 二级评论
                ForEach(comment.children, (child1: Comment) => {
                  Column() {
                    Row() {
                      Image(child1.user.avatar)
                        .width(26)
                        .height(26)
                        .borderRadius(13)
                        .margin({ right: 8 })

                      Row() {
                        Row() {
                          Text(child1.user.nickname)
                            .fontSize(13)
                            .fontWeight(FontWeight.Medium)

                          Text(new Date(child1.comment_time).toLocaleString().slice(0, 16))
                            .fontSize(11)
                            .margin({ left: 8 })
                            .fontColor(Color.Gray)
                        }
                        .layoutWeight(1)

                        Row() {
                          Button() {
                            Image(this.likeMap.get(child1.comment_id) ? $r('app.media.liked') : $r('app.media.like'))
                              .width(20)
                              .height(20)
                          }
                          .type(ButtonType.Normal)
                          .backgroundColor(Color.Transparent)
                          .onClick(() => {
                            let current = this.likeMap.get(child1.comment_id) ?? false
                            this.likeMap.set(child1.comment_id, !current)
                            if (!current) child1.like_count += 1
                            else child1.like_count -= 1
                          })

                          Text(`${child1.like_count}`)
                            .fontSize(11)
                            .fontColor(Color.Gray)
                            .margin({ left: 4 })
                        }
                      }
                      .alignItems(VerticalAlign.Center)
                      .justifyContent(FlexAlign.SpaceBetween)
                      .layoutWeight(1)
                    }
                    .alignItems(VerticalAlign.Center)
                    .margin({ bottom: 4 })

                    Row() {
                      Text(`回复${comment.user.nickname}: ` + child1.content)
                        .fontSize(14)
                    }
                    .width('100%')
                    .padding({left:40,bottom:10})

                    if (child1.medias.length > 0) {
                      Row() {
                        ForEach(child1.medias, (media: Media) => {
                          Image(media.url)
                            .width(50)
                            .height(50)
                            .margin({ right: 6 })
                            .borderRadius(5)
                        })
                      }
                      .width('100%')
                      .padding({left:40,bottom:10})
                      .margin({ top: 6 })
                    }

                    // 三级评论递归
                    ForEach(child1.children, (child2: Comment) => {
                      Column() {
                        Row() {
                          Image(child2.user.avatar)
                            .width(24)
                            .height(24)
                            .borderRadius(12)
                            .margin({ right: 8 })

                          Row() {
                            Row() {
                              Text(child2.user.nickname)
                                .fontSize(13)
                                .fontWeight(FontWeight.Medium)

                              Text(new Date(child2.comment_time).toLocaleString().slice(0, 16))
                                .fontSize(11)
                                .margin({ left: 8 })
                                .fontColor(Color.Gray)
                            }
                            .layoutWeight(1)

                            Row() {
                              Button() {
                                Image(this.likeMap.get(child2.comment_id) ? $r('app.media.liked') : $r('app.media.like'))
                                  .width(20)
                                  .height(20)
                              }
                              .type(ButtonType.Normal)
                              .backgroundColor(Color.Transparent)
                              .onClick(() => {
                                let current = this.likeMap.get(child2.comment_id) ?? false
                                this.likeMap.set(child2.comment_id, !current)
                                if (!current) child2.like_count += 1
                                else child2.like_count -= 1
                              })

                              Text(`${child2.like_count}`)
                                .fontSize(11)
                                .fontColor(Color.Gray)
                                .margin({ left: 4 })
                            }
                          }
                          .alignItems(VerticalAlign.Center)
                          .justifyContent(FlexAlign.SpaceBetween)
                          .layoutWeight(1)
                        }
                        .alignItems(VerticalAlign.Center)
                        .margin({ bottom: 4 })

                        Row() {
                          Text(`回复${child1.user.nickname}: ` + child2.content)
                            .fontSize(14)
                        }
                        .width('100%')
                        .padding({left:35,bottom:10})

                        if (child2.medias.length > 0) {
                          Row() {
                            ForEach(child2.medias, (media: Media) => {
                              Image(media.url)
                                .width(50)
                                .height(50)
                                .margin({ right: 6 })
                                .borderRadius(5)
                            })
                          }
                          .width('100%')
                          .padding({left:35,bottom:10})
                          .margin({ top: 6 })
                        }
                      }
                      .margin({ left: 40, bottom: 12 })
                    })
                  }
                  .margin({ left: 20, bottom: 12 })
                })
              }
              .margin({ bottom: 16 })
            })
          }
          .width('100%')
          .padding({ left: 0, right: 0 })













          // 到底了提示
          Text('- 到底了 -')
            .fontSize(13)
            .fontColor(Color.Gray)
            .alignSelf(ItemAlign.Center)
            .margin({ top: 40, bottom: 40 });
        }
        .width('100%')
        .padding({ left: 12, right: 12 });
      }
      .width('100%')
      .flexGrow(1)
      .backgroundColor(Color.White);

      // 多媒体面板
      if (this.showMediaPanel) {
        // 遮罩层，点击关闭
        Column()
          .width('100%')
          .height('100%')
          .position({ left: 0, top: 0 })
          .backgroundColor('#80000000')
          .onClick(() => {
            this.showMediaPanel = false;
          });

        // 多媒体选项菜单
        Column() {
          Button() {
            Text('相册').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(40)
          .backgroundColor('#f9f9f9')
          .margin({ bottom: 8 })
          .onClick(() => {
            // 打开相册逻辑
          });

          Button() {
            Text('拍照').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(40)
          .backgroundColor('#f9f9f9')
          .margin({ bottom: 8 })
          .onClick(() => {
            // 拍照逻辑
          });

          Button() {
            Text('分享').fontSize(16).fontColor(Color.Black);
          }
          .width('100%')
          .height(40)
          .backgroundColor('#f9f9f9')
          .margin({ bottom: 8 })
          .onClick(() => {
            // 分享逻辑
          });

          Button() {
            Text('取消').fontSize(16).fontColor(Color.Gray);
          }
          .width('100%')
          .height(40)
          .backgroundColor('#f9f9f9')
          .onClick(() => {
            this.showMediaPanel = false;
          });
        }
        .position({ bottom: 0, left: 0 })
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .height(200)
      }

      // 回复输入弹窗
      if (this.showReplyInput) {
        // 遮罩层
        Column()
          .width('100%')
          .height('100%')
          .position({ top: 0, left: 0 })
          .backgroundColor('#80000000')
          .onClick(() => {
            this.showReplyInput = false
          });

        // 输入框区域（弹窗底部）
        Row() {
          TextInput({ placeholder: '说点什么吧...' })
            .layoutWeight(1)
            .height(40)
            .fontSize(16)
            .padding({ left: 10, right: 10 })
            .backgroundColor('#f0f0f0')
            .borderRadius(20)
            .onChange((value: string) => {
              this.replyInputValue = value;
            });

          if (this.replyInputValue.length === 0) {
            Button() {
              Image($r('app.media.add')).width(32).height(32);
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .margin({ left: 8 })
            .onClick(() => {
              this.showMediaPanel = true;
            });
          } else {
            Button() {
              Text('发送')
                .fontSize(16)
                .fontColor(Color.White);
            }
            .width(64)
            .height(36)
            .backgroundColor(Color.Red)
            .borderRadius(18)
            .margin({ left: 8 })
            .onClick(() => {
              // 发送回复逻辑
              console.log('发送回复:', this.replyInputValue)
              this.replyInputValue = ''
              this.showReplyInput = false
            });
          }
        }
        .position({ bottom: 0, left: 0 })
        .width('100%')
        .padding({ left: 12, right: 12, top: 8, bottom: 12 })
        .backgroundColor(Color.White);
      }


    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }

}

