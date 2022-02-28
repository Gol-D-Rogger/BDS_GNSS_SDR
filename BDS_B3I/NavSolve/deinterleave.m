function subframe = deinterleave(ori_subframe)
    subframe = [ori_subframe(1:2:end) ori_subframe(2:2:end)];
end