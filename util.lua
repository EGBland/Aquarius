local util = {}

function util.printTable(tab, indents)
    indents = indents or 0
    for k, v in pairs(tab) do
        if type(v) == "table" then
            print(k, v, #v)
            util.printTable(v, indents + 1)
        else
            if indents == 0 then
                print(k, v)
            else
                print("", k, v)
            end
        end
    end
end

function util.pickRandom(tab)
    -- enumerate table
    local enum = {}
    for k in pairs(tab) do table.insert(enum, k) end
    return tab[enum[math.random(#enum)]]
end

function util.printTransform(transform)
    local mat = {transform:getMatrix()}
    for i = 0, 3 do
        print(mat[4 * i + 1], mat[4 * i + 2], mat[4 * i + 3], mat[4 * i + 4])
    end
end

function util.deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[util.deepcopy(orig_key, copies)] = util.deepcopy(
                                                            orig_value, copies)
            end
            setmetatable(copy, util.deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function util.clamp(x)
    local exp = -15
    if math.abs(x) < math.pow(10, exp) then
        return 0
    else
        return x
    end
end

function util.rotatePoint(x, y, tx, ty, theta)
    return (x - tx) * math.cos(-theta) - (y - ty) * math.sin(-theta) + tx,
           (x - tx) * math.sin(-theta) + (y - ty) * math.cos(-theta) + ty
end

return util
