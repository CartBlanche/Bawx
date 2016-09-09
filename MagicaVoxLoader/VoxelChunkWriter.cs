﻿using Microsoft.Xna.Framework.Content.Pipeline;
using Microsoft.Xna.Framework.Content.Pipeline.Serialization.Compiler;

namespace MagicaVoxLoader
{
    [ContentTypeWriter]
    public class VoxelChunkWriter : ContentTypeWriter<ChunkContent>
    {
        public override string GetRuntimeReader(TargetPlatform targetPlatform)
        {
            return "VoxViewerDx.VoxelChunkReader, VoxViewerDx";
        }

        protected override void Write(ContentWriter output, ChunkContent value)
        {
            output.Write(value.SizeX);
            output.Write(value.SizeY);
            output.Write(value.SizeZ);
            output.Write(value.Position);
            var count = value.Blocks.Length;
            output.Write(count);

            for (var i = 0; i < count; i++)
            {
                var b = value.Blocks[i];
                output.Write(b.Position);
                output.Write(b.Color);
            }
        }
    }
}