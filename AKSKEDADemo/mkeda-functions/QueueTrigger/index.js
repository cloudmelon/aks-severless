module.exports = async function (context, myQueueItem) {

    context.log('melon JavaScript queue trigger function processed work item', myQueueItem);
};