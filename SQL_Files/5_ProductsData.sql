/*
Robin Johnson
5/1/24

Script that inserts dummy data into the Products table
*/

INSERT INTO Products
    (ProductName,CategoryName,DesignName,Price,Stock)
VALUES
    ('SpicyPrint', 'Print', 'Spicy.png', '$10.00', 34),
    ('SpicyKeychain', 'Keychain', 'Spicy.png', '$8.00', 25),
    ('SpicySticker', 'Sticker', 'Spicy.png', '$5.00', 2),
    ('PuddlePrint', 'Print', 'Puddle.png', '$10.00', 45),
    ('SplashWallPrint', 'Print', 'SplashWall.png', '$10.00', 21),
    ('GreenFBPrint', 'Print', 'GreenFB.png', '$10.00', 43),
    ('ReachPrint', 'Print', 'Reach.png', '$10.00', 23),
    ('PinkIconPrint', 'Print', 'PinkIcon.png', '$10.00', 1),
    ('PinkIconSticker', 'Sticker', 'PinkIcon.png', '$5.00', 23),
    ('SmileIconSticker', 'Sticker', 'SmileIcon.png', '$5.00', 3),
    ('DabSticker', 'Sticker', 'Dab.png', '$3.00', 9),
    ('DabKeychain', 'Keychain', 'Dab.png', '$8.00', 12),
    ('WrennAndRemySticker', 'Sticker', 'WrennAndRemy.png', '$5.00', 10),
    ('WrennAndRemyKeychain', 'Keychain', 'WrennAndRemy.png', '$8.00', 24),
    ('SM Icon Commission', 'SM Icon Commission', NULL, '$50.00', NULL),
    ('SM Banner Commission', 'SM Banner Commission', NULL, '$50.00', NULL),
    ('Fullbody Commission', 'Fullbody Commission', NULL, '$100.00', NULL),
    ('YCH Team Commission', 'YCH Team Commission', NULL, '$40.00', NULL),
    ('YCH Couple Commission', 'YCH Couple Commission', NULL, '$30.00', NULL),
    ('YCH Individual Commission', 'YCH Individual Commission', NULL, '$20.00', NULL),
    ('YouTube Emote Commission', 'YouTube Emote Commission', NULL, '$50.00', NULL),
    ('YouTube Sprite Commission', 'YouTube Sprite Commission', NULL, '$100.00', NULL);