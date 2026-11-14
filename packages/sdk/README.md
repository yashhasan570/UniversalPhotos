# @Universal Photos/sdk

A TypeScript SDK for interfacing with the [Universal Photos](https:///) API.

## Install

```bash
npm i --save @Universal Photos/sdk
```

## Usage

For a more detailed example, check out the [`@Universal Photos/cli`](https://github.com/yashhasan570/UniversalPhotos/tree/main/cli).

```typescript
import { getAllAlbums, getMyUser, init } from "@Universal Photos/sdk";

const API_KEY = "<API_KEY>"; // process.env.UNIVERSAL PHOTOS_API_KEY

init({ baseUrl: "https://demo./api", apiKey: API_KEY });

const user = await getMyUser();
const albums = await getAllAlbums({});

console.log({ user, albums });
```
