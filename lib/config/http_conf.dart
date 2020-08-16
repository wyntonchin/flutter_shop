//Android模拟器需要使用本机电脑ip
//const base_url = 'http://127.0.0.1:3000';
const base_url = 'http://192.168.1.13:3000/';
const servicePath = {
  'getHomePageContent': base_url + 'getHomePageContent',
  'getHotGoods': base_url + 'getHotGoods',
  'getCategory': base_url + 'getCategory',
  'getCategoryGoods': base_url + 'getCategoryGoods',
  'getGoodDetail': base_url + 'getGoodDetail',
};
