# REST API Endpoints

Restrict Public Access to WP REST APIs

All the REST APIs listed below are protected from public access. You can uncheck the checkboxes to make it publicly accessible.
 / REST API ROOT

    On this website, the REST API root is http://bhaaie/wp-json/
     /batch/v1

 /oembed/1.0

     /oembed/1.0/embed
     /oembed/1.0/proxy

 /wp/v2

     /wp/v2/posts
     /wp/v2/posts/(?P<id>[\d]+)
     /wp/v2/posts/(?P<parent>[\d]+)/revisions
     /wp/v2/posts/(?P<parent>[\d]+)/revisions/(?P<id>[\d]+)
     /wp/v2/posts/(?P<id>[\d]+)/autosaves
     /wp/v2/posts/(?P<parent>[\d]+)/autosaves/(?P<id>[\d]+)
     /wp/v2/pages
     /wp/v2/pages/(?P<id>[\d]+)
     /wp/v2/pages/(?P<parent>[\d]+)/revisions
     /wp/v2/pages/(?P<parent>[\d]+)/revisions/(?P<id>[\d]+)
     /wp/v2/pages/(?P<id>[\d]+)/autosaves
     /wp/v2/pages/(?P<parent>[\d]+)/autosaves/(?P<id>[\d]+)
     /wp/v2/media
     /wp/v2/media/(?P<id>[\d]+)
     /wp/v2/media/(?P<id>[\d]+)/post-process
     /wp/v2/media/(?P<id>[\d]+)/edit
     /wp/v2/wp_block
     /wp/v2/wp_block/(?P<id>[\d]+)
     /wp/v2/wp_block/(?P<id>[\d]+)/autosaves
     /wp/v2/wp_block/(?P<parent>[\d]+)/autosaves/(?P<id>[\d]+)
     /wp/v2/types
     /wp/v2/types/(?P<type>[\w-]+)
     /wp/v2/statuses
     /wp/v2/statuses/(?P<status>[\w-]+)
     /wp/v2/taxonomies
     /wp/v2/taxonomies/(?P<taxonomy>[\w-]+)
     /wp/v2/categories
     /wp/v2/categories/(?P<id>[\d]+)
     /wp/v2/tags
     /wp/v2/tags/(?P<id>[\d]+)
     /wp/v2/users
     /wp/v2/users/(?P<id>[\d]+)
     /wp/v2/users/me
     /wp/v2/users/(?P<user_id>(?:[\d]+|me))/application-passwords
     /wp/v2/users/(?P<user_id>(?:[\d]+|me))/application-passwords/(?P<uuid>[\w\-]+)
     /wp/v2/comments
     /wp/v2/comments/(?P<id>[\d]+)
     /wp/v2/search
     /wp/v2/block-renderer/(?P<name>[a-z0-9-]+/[a-z0-9-]+)
     /wp/v2/block-types
     /wp/v2/block-types/(?P<namespace>[a-zA-Z0-9_-]+)
     /wp/v2/block-types/(?P<namespace>[a-zA-Z0-9_-]+)/(?P<name>[a-zA-Z0-9_-]+)
     /wp/v2/settings
     /wp/v2/themes
     /wp/v2/plugins
     /wp/v2/plugins/(?P<plugin>[^.\/]+(?:\/[^.\/]+)?)
     /wp/v2/block-directory/search

 /wp-site-health/v1

     /wp-site-health/v1/tests/background-updates
     /wp-site-health/v1/tests/loopback-requests
     /wp-site-health/v1/tests/dotorg-communication
     /wp-site-health/v1/tests/authorization-header
     /wp-site-health/v1/directory-sizes

