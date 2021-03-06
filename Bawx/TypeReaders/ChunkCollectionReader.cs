﻿using System.Collections.Generic;
using Bawx.VoxelData;
using Microsoft.Xna.Framework.Content;

namespace Bawx.TypeReaders
{
    public class ChunkCollectionReader : ContentTypeReader<ChunkCollection>
    {
        protected override ChunkCollection Read(ContentReader reader, ChunkCollection existingInstance)
        {
            var count = reader.ReadInt32();

            var chunks = new List<Chunk>(count);

            for (var i = 0; i < count; i++)
            {
                var chunk = reader.ReadObject<Chunk>();
                chunks.Add(chunk);
            }

            return new ChunkCollection(chunks);
        }
    }
}