local ReplicatedStorage = game:GetService('ReplicatedStorage')

local jest = require('@pkg/@jsdotlua/jest')

local jestRoots = {
    ReplicatedStorage:FindFirstChild('node_modules')
        :FindFirstChild('@aceworks-studio')
        :FindFirstChild('math'),
    ReplicatedStorage:FindFirstChild('node_modules')
        :FindFirstChild('@aceworks-studio')
        :FindFirstChild('random'),
    ReplicatedStorage:FindFirstChild('node_modules')
        :FindFirstChild('@aceworks-studio')
        :FindFirstChild('state-machine'),
    ReplicatedStorage:FindFirstChild('node_modules')
        :FindFirstChild('@aceworks-studio')
        :FindFirstChild('string'),
    ReplicatedStorage:FindFirstChild('node_modules')
        :FindFirstChild('@aceworks-studio')
        :FindFirstChild('time'),
}

local success, result = jest.runCLI(ReplicatedStorage, {}, jestRoots):await()

if not success then
    error(result)
end

task.wait(0.5)
