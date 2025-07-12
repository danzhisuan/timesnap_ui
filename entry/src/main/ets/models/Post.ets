import { Comment } from './Comment'
import { Media } from './Media'
import { CollectStats, LikeStats } from './Stats'
import { Tag } from './Tag'
import { User } from './User'

interface PostSimple {
  post_id: number
  title: string
  publisher: User
  like_stats: LikeStats
  cover_url: string
}
interface Permission {
  view_permission: string
  comment_permission: string
}

interface PostDetail {
  collect_stats: CollectStats
  browse_count: number
  comment_count: number
  publish_time: string
  post_simple: PostSimple
  content: string
  permission: Permission
  medias: Media[]
  tags: Tag[]
  comments: Comment[]
}