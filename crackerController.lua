local component = require "component"
local transposer = component.transposer
local sides = require "sides"

--bottom = 0; top = 1; north = 2; south = 3; west = 4; east = 5;
--assign below variables to where tanks are located
local h_fuel = 5
local r_gas = 1
local l_fuel = 4
local input_bus = 3

local capacity = transposer.getFluidInTank(input_bus)[1]["capacity"]
--order is to alternate between the input fluids. Possible values are 1, 2, etc depending on number of input fluids
local order = 1
local amt = 0

while true do
    os.sleep(1)
    if transposer.getFluidInTank(input_bus)[1]["amount"] == 0 then
        if order == 1 then
            order = 2
            goto first
        elseif order == 2 then
            order = 3
            goto second
        elseif order == 3 then
            order = 1
            goto third
        end
        --checks first input
        ::first::
        amt = transposer.getFluidInTank(h_fuel)[1]["amount"]
        if amt//1000 > 0 then
            if amt > capacity then
                transposer.transferFluid(h_fuel, input_bus, capacity)
                print(capacity .. " heavy fuel was transfered")
                goto continue
            end
            transposer.transferFluid(h_fuel, input_bus, (amt//1000)*1000)
            print((amt//1000)*1000 .. " heavy fuel was transfered")
            goto continue
        end
        --checks second input
        ::second::
        amt = transposer.getFluidInTank(l_fuel)[1]["amount"]
        if amt//1000 > 0 then
            if amt > capacity then
                transposer.transferFluid(l_fuel, input_bus, capacity)
                print(capacity .. " light fuel was transfered")
                goto continue
            end
            transposer.transferFluid(l_fuel, input_bus, (amt//1000)*1000)
            print((amt//1000)*1000 .. " light fuel was transfered")
            goto continue
        end
        --checks third input
        ::third::
        amt = transposer.getFluidInTank(r_gas)[1]["amount"]
        if amt//1000 > 0 then
            if amt > capacity then
                transposer.transferFluid(r_gas, input_bus, capacity)
                print(capacity .. " refinery gas was transfered")
                goto continue
            end
            transposer.transferFluid(r_gas, input_bus, (amt//1000)*1000)
            print((amt//1000)*1000 .. " refinery gas was transfered")
            goto continue
        end
    end
    ::continue::
end
