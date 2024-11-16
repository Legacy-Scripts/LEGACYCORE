# LGF HUD

<table>
  <tr>
    <td><img src="https://cdn.discordapp.com/attachments/1217899422604595300/1266543402950983731/image_1.png?ex=66a587f6&is=66a43676&hm=75b3cd5852985b1b1d7f5a3a90d711f92fb27fddcf022f3b2bbe6e6e4a5e5485&" alt="Pin Creation" width="300"/></td>
    <td><img src="https://cdn.discordapp.com/attachments/1217899422604595300/1266543871727243305/image_2.png?ex=66a58866&is=66a436e6&hm=5febf6b49efe4e3a948355c649680395a25c7f680508d0f733350f60dfffd14d&" alt="Pin Creation" width="300"/></td>
    <td><img src="https://cdn.discordapp.com/attachments/1217899422604595300/1266543872021106782/image_3.png?ex=66a58866&is=66a436e6&hm=c317a9f72060c03819c079c2460d71a104732449d2df87413bc50c7989133a8e&" alt="Pin Creation" width="300"/></td>
  </tr>
</table>

This document provides guidance on how to use LGF HUD, including examples for client-side and server-side usage for notification and other functions, along with details on available parameters and transitions.

## Notification Provider

**Type:**

- `'success'` : Indicates a successful operation or positive feedback.
- `'error'` : Indicates an error or failure.
- `'info'` : Provides general information or updates.
- `'warning'` : Indicates a warning or important notice.

**Position:**

- `'top-right'` : Notification appears at the top right of the screen.
- `'bottom-right'` : Notification appears at the bottom right of the screen.
- `'top-left'` : Notification appears at the top left of the screen.
- `'bottom-left'` : Notification appears at the bottom left of the screen.

**Transition:** (https://v6.mantine.dev/core/transition/?t=props)

- `'slide-left'` 
- `'slide-right'` 
- `'fade'`
- `'scale'` 
- `'scale-y'` 
- `'scale-x'` 
- `'skew-up'` 
- `'skew-down'` 
- `'rotate-left'` 
- `'rotate-right'`
- `'slide-down'`
- `'slide-up'` 
- `'pop'` 
- `'pop-bottom-left'`
- `'pop-bottom-right'` 
- `'pop-top-left'` 
- `'pop-top-right'` 

## Notification Function

The `Notification` function is used to send a notification to the client.

### Example Usage

```lua
-- SERVER SIDE
    lib.TriggerClientEvent('LGF_HUD:Notify:SendNotification', src, {
        Type = 'info',
        Message = 'Forza Juve Fuck Inter',
        Duration = 5000,
        Title = 'Title Notification',
        Position = 'top left',
        Transition = 'slide-right',
    })
    -- CLIENT SIDE USING EXPORTS
    exports.LGF_Hud:SendNotification({
        Type = 'info',
        Message = 'Forza Juve Fuck Inter',
        Duration = 5000,
        Title = 'Title Notification',
        Position = 'top-left',
        Transition = 'slide-right',
    })
```
