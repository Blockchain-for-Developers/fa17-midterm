
const Queue = artifacts.require("./Queue.sol");

contract('TestQueue', function(accounts){
    let queue;
    beforeEach(async function() {
        let q = await Queue.new(5);
        queue = q;
    });

    describe('Test queue operations', function(){
        it("Testing enqueue operations, qsize should increment upon enqueue",  async function() {
            await queue.enqueue(0);
            let size = await queue.qsize.call();
            assert.equal( size, 1, "qsize should equal 1");
        }),
        it("Testing enqueue operations, adding more than 5 participants should fail.", async function() {
            for(let i = 0; i < 10; i++){
                await queue.enqueue(i);
            }
            let size = await queue.qsize.call();
            assert.equal(size, 5, "qsize should never be more than 5");
        }),
        it("Testing dequeue after enqueue", async function() {
            await queue.enqueue(1);
            await queue.enqueue(2);
            await queue.enqueue(3);
            await queue.dequeue();
            let size = await queue.qsize.call();
            assert.equal(size, 2, "Adding 3 participants and dequeueing, should result in 2 participants.");
        }),
        it("getFirst should fetch address correspponding to the first participant in queue", async function() {
                await queue.enqueue(accounts[0]);
                await queue.enqueue(accounts[1]);
                let first = await queue.getFirst.call();
                assert.equal(first, accounts[0], "First person in queue");
        }),
        it("checkPlace should return position of participant", async function() {
                await queue.enqueue(accounts[0]);
                await queue.enqueue(accounts[1]);
                await queue.enqueue(accounts[2]);
                let position = await queue.checkPlace.call(accounts[1]);
                assert.equal(position, 1, "accounts[1] is at position 1");
        })
    });
    describe("Test participant time limits", function(){
        it("checkTime for first participant in queue should work", async function(){
            await queue.enqueue(accounts[0]);

            setTimeout( async function(){
                await queue.checkTime();
                let size = await queue.qsize.call();
                assert.equal(size, 0, "checktime after waiting 3 seconds should remove participant from queue");
            }, 3000);
        })
    })
});
