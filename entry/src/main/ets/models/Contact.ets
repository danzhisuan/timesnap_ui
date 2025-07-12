import { UserSimple } from './User';

export interface  Contact {
  contact_id: number;
  friend: UserSimple;
  latest_message: string;
}