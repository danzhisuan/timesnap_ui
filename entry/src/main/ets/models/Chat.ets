import { UserSimple } from './User';

interface Chat {
  chat_id : number;
  contact_id: number;
  sender: UserSimple;
  send_time: Date;
  content: string;
  isImage?: boolean;
}