getCounterCollection = (collection) ->
  collection.rawCollection()


callCounter = (method, collection, args...) ->
  Counters = getCounterCollection(collection)
  if Meteor.wrapAsync?
    Meteor.wrapAsync(_.bind(Counters[method], Counters))(args...)
  else
    future = new (Npm.require(Npm.require('path').join('fibers', 'future')))()
    Counters[method].call(Counters, args..., future.resolver())
    future.wait()


export deleteCounters = (collection) ->
  callCounter('remove', collection, {}, {safe: true})


export incrementCounter = (collection, counterName, amount = 1) ->
  newDoc = callCounter(
    'findAndModify',
    collection,
    {_id: counterName},         # query
    null,                       # sort
    {$inc: {next_val: amount}},      # update
    {new: true, upsert: true},  # options
  )                             # callback added by wrapAsync
  return newDoc?.value?.next_val or newDoc.next_val


export decrementCounter = (collection, counterName, amount = 1) ->
  _incrementCounter(collection, counterName, -amount)


export setCounter = (collection, counterName, value) ->
  callCounter(
    'update',
    collection,
    {_id: counterName},
    {$set: {next_val: value}}
  )
  return
