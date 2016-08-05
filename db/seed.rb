require './models/dm_user'
require './models/dm_report'

DmUser.create(
  email: 'admin@example.com',
  password: 'password',
  admin: true
)

DmUser.create(
  email: 'default@default.com',
  password: 'password'
)
