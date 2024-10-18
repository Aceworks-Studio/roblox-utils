[![checks](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml/badge.svg)](https://github.com/Aceworks-Studio/roblox-utils/actions/workflows/test.yml)
![version](https://img.shields.io/github/package-json/v/Aceworks-Studio/roblox-utils)
[![GitHub top language](https://img.shields.io/github/languages/top/Aceworks-Studio/roblox-utils)](https://github.com/luau-lang/luau)
![license](https://img.shields.io/npm/l/@aceworks-studio/state-machine)
![npm](https://img.shields.io/npm/dt/@aceworks-studio/state-machine)

# @aceworks-studio/state-machine

A Luau utility to easily create simple state machines.

## Installation

Add `@aceworks-studio/state-machine` in your dependencies:

```bash
yarn add @aceworks-studio/state-machine
```

Or if you are using `npm`:

```bash
npm install @aceworks-studio/state-machine
```

## Content

### create

```luau
function StateMachine.create(config: StateMachineConfiguration): () -> ()

type StateController = {
    addCleanup: (...Teardown) -> () -> (),
    next: (nextState: string, nextConfig: any) -> never,
}

type StateEvent = { state: string, config: any, time: number }
type StateHistory = { StateEvent }

type StateMachineConfiguration = {
    defaultState: string,
    defaultStateConfig: any,
    states: {
        [string]: (StateController, config: any) -> (),
    },
    onStateChange: (state: string, config: any) -> ()?,
    onStateHistoryChange: (StateHistory) -> ()?,
}
```

#### Example

```lua
create({
	defaultState = "startup",
	defaultStateConfig = { mapName = "defaultMap" },
	states = {
		startup = function(controller, config)
			controller.addCleanup(task.spawn(function()
				local model = loadMap(config.mapName)
				task.wait(2)
				controller.next("match", { model = model })
			end))
		end,
		match = function(controller, config)
			teleportAllPlayersInMap(config.model)

			controller.addCleanup(
				task.delay(30, function()
					controller.next("expired")
				end),
				task.spawn(function()
					Time.yieldUntil(0.2, function()
						return not hasEnoughPlayer()
					end)

					local remaining = getRemainingPlayers()
					local remainingCount = #remaining

					if remainingCount == 1 then
						controller.next("winner", { winner = remaining[1] })
					else
						controller.next("startup", { mapName = pickRandomMap() })
					end
				end)
			)
		end,
		winner = function(controller, config)
			print("winner!", config.winner)
			controller.addCleanup(task.delay(3, function()
				controller.next("startup")
			end))
		end,
		expired = function(controller)
			print("expired!")
			controller.addCleanup(task.delay(3, function()
				controller.next("startup")
			end))
		end,
	},
})
```


## License

This project is available under the MIT license. See [LICENSE.txt](../../LICENSE.txt) for details.

## Other Lua Environments Support

If you would like to use this library on a Lua environment where it is currently incompatible, open an issue (or comment on an existing one) to request the appropriate modifications.

The library uses [darklua](https://github.com/seaofvoices/darklua) to process its code.
