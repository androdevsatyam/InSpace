import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class StorageReclaimCard extends StatelessWidget {
  final double reclaimableGb;
  final VoidCallback onPressed;
  const StorageReclaimCard({super.key, required this.reclaimableGb, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final empty = reclaimableGb == 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        gradient: LinearGradient(colors: empty ? [const Color(0xFF064E3B), AppColors.card] : [const Color(0xFF1E1B4B), AppColors.card, const Color(0xFF064E3B)]),
        border: Border.all(color: empty ? AppColors.emerald.withOpacity(.45) : AppColors.indigo.withOpacity(.4)),
      ),
      child: empty
          ? const Row(children: [Icon(Icons.check_circle_rounded, color: AppColors.emerald), SizedBox(width: 10), Expanded(child: Text('14.8 GB successfully freed. Streaming proxies stay ready.', style: TextStyle(fontWeight: FontWeight.w700)))])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.cleaning_services_rounded, color: AppColors.emerald), const SizedBox(width: 8), const Expanded(child: Text('DEVICE STORAGE OPTIMIZER', style: TextStyle(color: AppColors.emerald, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: .7))), _safePill()]),
              const SizedBox(height: 5),
              Text('${reclaimableGb.toStringAsFixed(1)} GB Ready to Free Up', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('12 heavy 4K videos are safely backed up in your Private Cloud Vault. Clear device copies without losing streaming access.', style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), height: 1.4)),
              const SizedBox(height: 14),
              ClipRRect(borderRadius: BorderRadius.circular(6), child: const SizedBox(height: 10, child: Row(children: [Expanded(flex: 54, child: ColoredBox(color: Color(0xFF64748B))), Expanded(flex: 22, child: ColoredBox(color: AppColors.indigo)), Expanded(flex: 12, child: ColoredBox(color: AppColors.emerald)), Expanded(flex: 12, child: ColoredBox(color: Color(0xFF334155)))]))),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onPressed, icon: const Icon(Icons.delete_sweep_rounded, color: Colors.black), label: Text('Free Up ${reclaimableGb.toStringAsFixed(1)} GB Device Space', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800)), style: FilledButton.styleFrom(backgroundColor: AppColors.emerald))),
            ]),
    );
  }

  Widget _safePill() => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.emerald.withOpacity(.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.emerald.withOpacity(.35))), child: const Text('Safe to Clear', style: TextStyle(fontSize: 10, color: Color(0xFF6EE7B7), fontWeight: FontWeight.w700)));
}
