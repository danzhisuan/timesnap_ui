import { UserSimple } from './User';

export interface  Contact {
  contact_id: string;
  friend: UserSimple;
  latest_message: string;
}