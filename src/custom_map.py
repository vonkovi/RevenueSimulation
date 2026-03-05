from mosstool.map.osm import RoadNet, Building
from mosstool.map.builder import Builder
from mosstool.util.format_converter import dict2pb
from mosstool.type import Map

# silicon valley!
min_latitude = 37.44287
max_latitude = 37.45391
min_longitude = -122.16192
max_longitude = -122.14322

projstr = f"+proj=tmerc +lat_0={(min_latitude + max_latitude) / 2} +lon_0={(min_longitude + max_longitude) / 2}"
rn = RoadNet(
    proj_str=projstr,
    max_latitude=max_latitude,
    min_latitude=min_latitude,
    max_longitude=max_longitude,
    min_longitude=min_longitude,
    proxies=None,
)
roadnet = rn.create_road_net()
building = Building(
    proj_str=projstr,
    max_latitude=max_latitude,
    min_latitude=min_latitude,
    max_longitude=max_longitude,
    min_longitude=min_longitude,
    proxies=None,
)
aois = building.create_building()
builder = Builder(
    net=roadnet,
    aois=aois,
    proj_str=projstr,
)
m = builder.build("map_name")
pb = dict2pb(m, Map())
with open("./map.pb", "wb") as f:
    f.write(pb.SerializeToString())