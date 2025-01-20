local SpatialMap = require('./SpatialMap')

export type SpatialMap<T> = SpatialMap.SpatialMap<T>

return {
    SpatialMap = SpatialMap,
}
