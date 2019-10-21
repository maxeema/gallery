import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unsplash_gallery/data.dart';
import 'package:unsplash_gallery/util.dart';

const _avatarSize = 128;
const _maxWidth = 300;

class DetailsScreen extends StatefulWidget {

  final Foto foto;

  const DetailsScreen(this.foto);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {

  Foto get foto => widget.foto;

  var _authorExpanded = false;

  _createFotoInfo() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () => launchUrl(foto.htmlUrl),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Tooltip(child: Text(
              makeUrlBeautiful(foto.htmlUrl),
              style: theme.textTheme.body1.apply(
                  color: Colors.blue
              ),
            ), message: "Url copied!"),
          )
        ),
        if (isNotEmpty(foto.description))
          Text(
            foto.description.trim(),
            textAlign: TextAlign.center,
            maxLines: 5,
            style: theme.textTheme.body1.apply(
              color: Colors.grey.shade500
            ),
          ),
      ],
    );
  }

  _createAuthorTile() {
    final theme = Theme.of(context);
    final author = widget.foto.author;
    final avatarUrl = author.prepareAvatarUrl(_avatarSize, window);
    print(avatarUrl);
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: isNotEmpty(author.unsplashUrl) ? () => launchUrl(author.unsplashUrl) : null,
          child: CircleAvatar(
            maxRadius: _avatarSize / 4,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        SizedBox(width: 16,),
        Expanded(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(author.name,
                style: theme.textTheme.title,
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
              SizedBox(height: 8,),
              Text('@${author.username}',
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.subtitle.apply(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),)
      ],
    );
  }

  _createAuthorDetails() {
    final theme = Theme.of(context);
    final author = widget.foto.author;
    final avatarUrl = author.prepareAvatarUrl(_avatarSize, window);
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: GestureDetector(
                onTap: isNotEmpty(author.unsplashUrl) ? () => launchUrl(author.unsplashUrl) : null,
                child: CircleAvatar(
                  maxRadius: _avatarSize / 2,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ),
            if (isNotEmpty(author.twitterUsername))
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: InkResponse(
                  onLongPress: ()=> copyToClipboard(author.twitterUsername),
                  onTap: () => launchTwitter(author.twitterUsername),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Tooltip(child: SvgPicture.asset(
                      assetsSvgIcon('twitter'),
                      width: 32, color: Colors.blue.shade500,
                    ), message: "Twitter name copied!"),
                  ),
                ),
              ),
            if (isNotEmpty(author.instagramUsername))
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkResponse(
                  onLongPress: ()=> copyToClipboard(author.instagramUsername),
                  onTap: () => launchInstagram(author.instagramUsername),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Tooltip(child: SvgPicture.asset(
                      assetsSvgIcon('instagram'),
                      width: 32, color: Colors.blue.shade500,
                    ), message: "Instagram name copied!"),
                  ),
                ),
              ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(author.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: theme.textTheme.title,
          ),
        ),

        if (isNotEmpty(author.location))
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: RichText(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.fade,
              text: TextSpan(
                  style: Theme.of(context).textTheme.caption.apply(
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(text: '',
                        style: theme.textTheme.overline.apply(
                          fontFamily: 'MaterialIcons',
                          color: Colors.grey.shade400,
                        )
                    ),
                    TextSpan(
                      text: author.location.trim()
                    )
                  ]
              ),
            )
          ),

        if (isNotEmpty(author.portfolioUrl) || isNotEmpty(author.unsplashUrl))
          InkWell(
            onTap: () => launchUrl(isNotEmpty(author.portfolioUrl) ? author.portfolioUrl : author.unsplashUrl),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Tooltip(child: Text(
                makeUrlBeautiful(isNotEmpty(author.portfolioUrl) ? author.portfolioUrl : author.unsplashUrl),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.body1.apply(
                    color: Colors.blue
                ),
              ), message: "Url copied!"),
            )
          ),

        if (isNotEmpty(author.bio))
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              author.bio.trim(),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.body1.apply(
                  color: Colors.grey.shade800
              ),
            ),
          ),
      ],
    );
  }

  _expandAuthor() {
    if (!_authorExpanded )
      setState(() { _authorExpanded = true; });
  }

  @override
  Widget build(BuildContext context) {
//    Future.delayed(Duration(milliseconds: 300), _expandAuthor);
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: _maxWidth.toDouble()),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: _createFotoInfo(),
            ),
            Divider(height: 2,),
            MaterialButton(
              onPressed: _authorExpanded ? null : () => _expandAuthor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: AnimatedCrossFade(
                  crossFadeState: _authorExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 250),
                  firstChild: _createAuthorTile(),
                  secondChild: _authorExpanded ? _createAuthorDetails() : SizedBox(),
                ),
              ),
            ),
          ],
        )
      )
    );
  }

}
