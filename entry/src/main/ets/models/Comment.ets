import { Media } from "./Media"
import { LikeStats } from "./Stats"
import { UserSimple } from "./User"


export interface  Comment {
  comment_id: string
  post_id: string
  commenter: UserSimple
  content: string
  medias: Media[]
  comment_time: Date
  like_stats:LikeStats
  children:Comment[]
}