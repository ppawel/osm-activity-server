function(doc) {
  key = [];

  for (i = 0; i < doc.to.length; i++) {
    user_id = doc.to[i]['id'];

    if (user_id == 'all') {
      emit(['all', doc.published], doc._rev);
      break;
    }

    emit([user_id, doc.published], doc._rev);
  }
}

