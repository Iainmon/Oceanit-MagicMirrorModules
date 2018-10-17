var scraper = require('google-search-scraper');
 
var options = {
  query: 'nodejs',
  limit: 10
};
 
scraper.search(options, function(err, url, meta) {
  // This is called for each result
  if(err) throw err;
  console.log(url);
  console.log(meta.title);
  console.log(meta.meta);
  console.log(meta.desc)
});