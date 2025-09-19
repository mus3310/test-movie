import { apiFetch } from './fetch';

const api = {
  get: (path: string, payload: Record<string, any> = {}, opts: RequestInit = {}) => {
    const query = new URLSearchParams(payload).toString();
    const url = query ? `${path}?${query}` : path;
    return apiFetch(url, { method: 'GET', ...opts });
  },

  post: (path: string, payload: Record<string, any> = {}, opts: RequestInit = {}) =>
    apiFetch(path, { method: 'POST', body: JSON.stringify(payload), ...opts }),

  put: (path: string, payload: Record<string, any> = {}, opts: RequestInit = {}) =>
    apiFetch(path, { method: 'PUT', body: JSON.stringify(payload), ...opts }),

  delete: (path: string, payload: Record<string, any> = {}, opts: RequestInit = {}) =>
    apiFetch(path, payload ? { method: 'DELETE', body: JSON.stringify(payload), ...opts } : { method: 'DELETE', ...opts })
};

export default api;