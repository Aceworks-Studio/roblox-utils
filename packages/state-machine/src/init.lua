local create = require('./create')

export type StateController = create.StateController
export type StateMachineConfiguration<T = {}> = create.StateMachineConfiguration<T>
export type StateEvent = create.StateEvent
export type StateHistory = create.StateHistory

return {
    create = create,
}
