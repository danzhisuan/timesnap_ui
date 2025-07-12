import { Comment } from './Comment'
import { Media } from './Media'
import { CollectStats, LikeStats } from './Stats'
import { Tag } from './Tag'
import { UserSimple } from './User'

interface PostSimple {
  post_id: number
  title: string
  publisher: UserSimple
  like_stats: LikeStats
  cover_url: string
}
interface Permission {
  view_permission: string
  comment_permission: string
}

interface PostDetail {
  post_simple: PostSimple
  content: string
  medias: Media[]
  permission: Permission
  publish_time: Date
  collect_stats: CollectStats
  browse_count: number
  comment_count: number
  tags: Tag[]
  comments: Comment[]
}