# Kudoso Blog Theme

The kudoso blog theme is based on the kudoso site design with elements pulled from an existing ghost theme. Ghost makes use of the .hbs (handle bar ) file type.

## Ghost Theme References

- [Handy Cheatsheet](http://www.gtheme.io/community/articles/1/ghost-theme-cheat-sheet)

## Theme Structure

- **blog.kudoso.com** (Theme)
    - **assets**
        - **styles**
            - **css**
                - application.css
            - **sass**
                - \_base.sass
                - \_blog.sass
                - \_config.sass
                - \_footer.sass
                - \_header.sass
                - \_hero.sass
                - \_home.sass
                - \_intro.sass
                - \_section.sass
                - \_vendor.sass
                - application.sass
        - **images**
        - **scripts**
    - **kit_html**
        - \_footer.kit
        - \_header.kit
        - \_news.kit
        - \_paths.kit
        - author.kit
        - default.kit
        - index.kit
        - page.kit
        - post.kit
    - **partials**
        - loop.hbs
        - pagination.hbs
    - author.hbs
    - default.hbs
    - index.hbs
    - page.hbs
    - post.hbs
    - tag.hbs
    - ...

## Modifying the Theme

The current workflow makes use of [CodeKit](http://incident57.com/codekit/), a mac app for compiling and managing front-end projects. Each [.kit](http://incident57.com/codekit/help.html#kit) file gets compiled to another file type of file. In this case CodeKit is generating .hbs (handle bar source) files in the root folder. All of the sass files compile to the `application.css` file.


## Ghost Cheat Sheet

#### Ghost Blog Details
- `{{@blog.url}}` The blog's URL as specified in the config.js file.
- `{{@blog.title}}` The blog title.
- `{{@blog.description}}` The blog's description
- `{{@blog.logo}}` The blog's logo (img src)
- `{{@blog.cover}}` The blog's cover image (img src)

#### Ghost Post Details
- `{{title}}` The post title
- `{{url}}` This outputs the relative URL of a post when used with a post context. It also has the option to output an absolute URL: `{{url absolute="true"}}`.
- `{{featured}}` Whether the post is featured post.
- `{{date}}` This outputs the date an article is published. This function uses moment.js and allows options to format the date before outputting.
- `{{excerpt}}` By default this outputs 50 words from the beginning of the post content and also strips out all HTML. You can customize the number of words used: `{{excerpt characters="140"}}`
- `{{content}}` This outputs the post content. You can also use this instead of {{excerpt}} to show a certain number of words without stripping HTML: `{{content words="100"}}`
- `{{tags}}` This outputs all the tags assigned to a post. Can be further customized to display a separator between each tag and also suffix and prefix
- `{{tag.name}}` This outputs name of a tag on individual post page. Can also be used as `{{name}}` when used inside the block expressions `{{#tags}}` and `{{/tags}}`

#### Ghost Author Details
- `{{author.name}}` The post authors name
- `{{author.bio}}` The Author's bio
- `{{author.location}}` The Author's location
- `{{author.email}}` The author's email depreciated since 0.5
- `{{author.website}}` The author's website
- `{{author.image}}` The author's avatar / profile image
- `{{author.cover}}` The author's personal cover image

#### Ghost Helpers
- `{{meta_title}}` Displayed in the document header. Based on the context outputs either the title of an individual post or the blog title.
- `{{meta_description}}` Currently displays only the blog description irrespective of the context.
- `{{body}}` When "default.hbs" is used to abstract common elements, the body tags help mark the position where the contents of a page such as "index.hbs" or "posts.hbs" are inserted inside "default.hbs"
- `{{body_class}}` Adds class name that can be targeted to style different pages. Currently outputs either "home-template", "post-template" or "archive-template". Additionally it also outputs "page" if the post is marked as a page and tag names based on the tags assigned to the page/post.
- `{{post_class}}` Useful for styling different posts.
- `{{has}}` helper has been created to provide a bit more flexibility in creating different layouts for posts in Ghost. The overall goal of the has helper is to allow you to ask questions about what the current context looks like:

```
    {{#post}}
        {{#has tag="photo"}}
            ...do something if this post has a tag of photo...
        {{else}}
            ...do something if this posts doesn't have a tag of photo...
        {{/has}}
    {{/post}}
```
Ghost 0.5 is the improvement of {{has}} helper to support author attributes:
```
    {{#post}}
        {{#has author="Joe Bloggs"}}
            ...do something if the author is Joe Bloggs
        {{else}}
            ...do something if the author is not Joe bloggs
        {{/has}}
    {{/post}}
```
- {{plural}} helper is added in Ghost 0.5.0 to help theme designers to formatting metadata. {{plural}} helper support display three output based on the condition is empty, one, or many.
```
    {{plural pagination.total empty='No posts' singular='% post' plural='% posts'}}
```

- `{{pagination}}` Outputs HTML consisting of links to "Older" & "Newer" posts along with the page number you are on. Can be overwritten by creating a file named "pagination.hbs" and placing it inside the "partials" folder.
- `{{ghost_head}}` Place just before the tag, it outputs the RSS feed link and the ghost version number.
- `{{ghost_foot}}` Placed before the body tag to output scripts. Currently outputs the jQuery file.
- `{{asset}}` Asset helper introduced in version 0.4 helps adding caching provides a more robust way to include theme assets such as css, js and images.
- `{{encode}}` URI encoded string, e.g. {{encode title}} to encode title for social sharing.
- `{{author}}` Full name of the author of a given post, or a blank string, underlying use {{author.name}}
- `{{log}}` You can use {{log}} to output debug messages to the server console. Perhaps the most interesting example of this is using {{log this}} to output the current handlebars context.

[Source: Cheat Sheet](http://www.gtheme.io/community/articles/1/ghost-theme-cheat-sheet)
