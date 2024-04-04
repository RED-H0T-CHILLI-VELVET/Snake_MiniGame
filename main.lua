_G.love = require("love")
--env = require("env")
lick = require "lick"
lick.reset = true

function love.load()
    gridXCount,gridYCount,cellSize=400,300,5

    function reset()
        directionQueue = {'right'}
        snakeAlive = true
        timer = 0
        gameSpeed = 0.05
        snakeSegments = {
            { x = 102, y = 100 },
            { x = 101, y = 100 },
            { x = 100, y = 100 },
            { x =  99, y = 100 },
            { x =  98, y = 100 },
            { x =  97, y = 100 },
            { x =  96, y = 100 },
            { x =  95, y = 100 },
            { x =  94, y = 100 },
            { x =  93, y = 100 },
            { x =  92, y = 100 },
            { x =  91, y = 100 },
            { x =  90, y = 100 },
            { x =  89, y = 100 },
            { x =  88, y = 100 },
        }
        moveFood()
    end

    function moveFood()
        --foodPosition = { x = love.math.random( 1, gridXCount), y = love.math.random( 1, gridYCount)}
        local validFoodPositions = {}
        
        for foodX = 1, gridXCount do
            for foodY = 1, gridYCount do
                local valid = true 

                for segmentIndex, segment in ipairs(snakeSegments) do
                    if foodX == segment.x and foodY == segment.y then
                        valid = false
                    end

                    if valid then
                        table.insert(validFoodPositions,{ x = foodX, y = foodY})
                    end
                end
            end
        end
        foodPosition = validFoodPositions[love.math.random(#validFoodPositions)]
        gameSpeed = gameSpeed * 0.9
    end

    reset()
end

function love.update(dt)
    timer = timer + dt

    

    if snakeAlive then
        if timer >= gameSpeed then
            timer = 0

            if #directionQueue > 1 then
                table.remove(directionQueue, 1)
            end

            local nextXPosition = snakeSegments[1].x 
            local nextYPosition = snakeSegments[1].y

            if directionQueue[1] == 'right' then
                nextXPosition = nextXPosition + 1 
                if nextXPosition > gridXCount then
                    nextXPosition = 1
                end
            elseif directionQueue[1] == 'left' then
                nextXPosition = nextXPosition - 1
                if nextXPosition < 1 then
                    nextXPosition = gridXCount
                end
            elseif directionQueue[1] == 'up' then
                nextYPosition = nextYPosition - 1
                if nextYPosition < 1 then
                    nextYPosition = gridYCount
                end
            elseif directionQueue[1] == 'down' then
                nextYPosition = nextYPosition + 1
                if nextYPosition > gridYCount then
                    nextYPosition = 1
                end
            end
            print("snake x = " ..snakeSegments[1].x )
            print("snake y = " ..snakeSegments[1].y )
            print("food x = " ..foodPosition.x )
            print("food y = " ..foodPosition.y )

            local canMove = true

            for segmentIndex, segment in ipairs(snakeSegments) do
                if segmentIndex ~= #snakeSegments and nextXPosition == segment.x and nextYPosition == segment.y then
                    canMove = false
                end
            end

            if canMove then
                table.insert(snakeSegments, 1, { x = nextXPosition, y = nextYPosition})
                if snakeSegments[1].x == foodPosition.x and snakeSegments[1].y == foodPosition.y then
                    moveFood()                                                                       
                else                                                                                 
                    table.remove(snakeSegments)                                                      
                end                                                                                  
            else
                snakeAlive = false
            end
        end
    elseif timer >= 2 then
        reset()
    end


end

    function love.keypressed(key)
        if key == 'right' 
            and directionQueue[#directionQueue] ~= 'left'
            and directionQueue[#directionQueue] ~= 'right' then
            table.insert(directionQueue, 'right')
        elseif key == 'left'
            and directionQueue[#directionQueue] ~= 'left' 
            and directionQueue[#directionQueue] ~= 'right' then
            table.insert(directionQueue, 'left')
        elseif key == 'up'
            and directionQueue[#directionQueue] ~= 'up' 
            and directionQueue[#directionQueue] ~= 'down' then
            table.insert(directionQueue, 'up')
        elseif key == 'down'
            and directionQueue[#directionQueue] ~= 'down' 
            and directionQueue[#directionQueue] ~= 'up' then
            table.insert(directionQueue, 'down')
        end
    end

function love.draw()

    local function drawCell(x,y)
        love.graphics.rectangle(
            'fill',
            (x - 1),
            (y - 1),
            cellSize - 1,
            cellSize - 1
        )
    end

    love.graphics.setColor( .28, .28, .28)
    love.graphics.rectangle( 'fill', 0, 0, gridXCount*cellSize, gridYCount*cellSize)
    for segmentIndex, segment in ipairs(snakeSegments) do 
        love.graphics.setColor( .6, 1, .32)
        drawCell(segment.x, segment.y)
    end

    love.graphics.setColor( 1, .3, .3)
    drawCell(foodPosition.x, foodPosition.y) 

    for directionIndex, direction in ipairs(directionQueue) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(
            'directionQueue['..directionIndex..']: '.. direction,
            15, 15 * directionIndex
            --snakeSegments[1]
        )
    end
end 
