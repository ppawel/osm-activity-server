function(doc) {
  key = [];

  for (i = 0; i < doc.to.length; i++) {
    user_id = doc.to[i]['id'];

    if (user_id == 'all') {
      key = ['all'];
      break;
    }

    key += user_id;
  }

  emit(key, doc._rev);
}

