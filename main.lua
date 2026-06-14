boardWidth = 10--地圖寬度(欄)
boardHeight = 20--地圖高度(列)

board = {}--建立空白地圖

for y = 1, boardHeight do--延伸y列(從第1列建立到第20列)
    board[y] = {}--建立第y列
    for x = 1, boardWidth do --在y上進行x的延伸(在這一列建立第1欄到第10欄)
        board[y][x] = 0--建立空格
    end
end

L={
{x=0,y=0},
{x=0,y=1},
{x=0,y=2},
{x=1,y=2}
}
T={
{x=0,y=0},
{x=1,y=0},
{x=2,y=0},
{x=1,y=1}
}
--J={
--{x=2,y=0},
--{x=0,y=1},
--{x=1,y=1},
--{x=2,y=1}
--}
I={
{x=0,y=0},
{x=1,y=0},
{x=2,y=0},
{x=3,y=0}
} 
O={
{x=0,y=0},
{x=1,y=0},
{x=0,y=1},
{x=1,y=1}
}

function love.load()

end

function love.keypressed(key)
  
end

function love.update(dt)

end

function love.draw()

end

local function canMove(shape, posX, posY)--建立canMove功能用於確認方塊是否可以移動新的位置
    for index, block in ipairs(shape) do --輪詢 shape 每一個組成方塊(block)
        local x = posX + block.x -- 計算方塊預期移動後的 x 位置(計算此小方塊移動後的實際 X 座標
        local y = posY + block.y -- 計算方塊預期移動後的 y 位置

        if x < 1 or x > boardWidth then--判斷x是否超出地圖左右邊界
            return false
        end

        if y > boardHeight then--判斷y是否超出地圖底部
            return false
        end

        if board[y] and board[y][x] == 1 then--判斷地圖中的x y 座標是否已有固定方塊
            return false
        end
    end

    return true
end
function spawnPiece()--建立新的隨機方塊

    local types = {--可生成的方塊種類
        shapes.L,
        shapes.T,
        shapes.J,
        shapes.I,
        shapes.O
    }

    currentShape = types[math.random(#types)]-- 隨機取得一個方塊形狀#types/ = types內元素數量/math.random() = 隨機產生編號/types[編號] = 取出對應方塊


    pieceX = 5--新方塊生成的X位置
    pieceY = 1--新方塊生成的Y位置

end
