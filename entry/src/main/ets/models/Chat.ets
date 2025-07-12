import { UserSimple } from './User';

interface Chat {
  chat_id : string;
  contact_id: string;
  sender: UserSimple;
  send_time: Date;
  content: string;
  isImage?: boolean;
}