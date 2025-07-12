//处理各种网络请求

import http from '@ohos.net.http';
import { Config } from '../configs/config';

export class ApiService {
  private baseUrl = Config.baseUrl;

  async get<T>(endpoint: string): Promise<T> {
    const url = this.baseUrl + endpoint;
    console.log('请求地址:', url);
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
      });

      if ((response.responseCode === 200 || response.responseCode === 201) && response.result) {
        return JSON.parse(response.result as string) as T;
      } else {
        throw new Error(`请求失败，状态码：${response.responseCode}`);
      }
    } catch (err) {
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(String(err));
      }
    } finally {
      httpRequest.destroy();
    }
  }

  async post<TReq,TRes>(endpoint: string, body: TReq): Promise<TRes> {
    const url = this.baseUrl + endpoint;
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData:JSON.stringify(body),
        }
      );

      if ((response.responseCode === 200 || response.responseCode === 201) && response.result) {
        return JSON.parse(response.result as string) as TRes;
      } else {
        throw new Error(`请求失败，状态码：${response.responseCode}`);
      }
    } catch (err) {
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(String(err));
      }
    } finally {
      httpRequest.destroy();
    }

  }
}
