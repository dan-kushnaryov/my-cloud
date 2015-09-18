name             'mrchub'
maintainer       'Danil V. Kushnaryov'
maintainer_email 'danil.kushnaryov@mrcplast.com'
license          'All rights reserved'
description      'MRC develop cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apache2'
depends 'mysql', '= 3.0.4'
depends 'php'
depends 'composer'
depends 'xdebug'
